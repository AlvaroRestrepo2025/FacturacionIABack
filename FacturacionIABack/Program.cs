using BMFacturacionIABack.CierreSesion;
using BMFacturacionIABack.Empresas;
using DMFacturacionIABack.CierreSesion;
using DMFacturacionIABack.Empresas;

var builder = WebApplication.CreateBuilder(args);

// Permite usar controladores API.
builder.Services.AddControllers();

// Configura Swagger para documentar y probar los endpoints de la API.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configura CORS para permitir conexión desde Angular local.
builder.Services.AddCors(options =>
{
    options.AddPolicy("AngularPolicy", policy =>
    {
        policy
            .WithOrigins("http://localhost:4200")
            .AllowAnyHeader()
            .AllowAnyMethod();
    });
});

// Registra la capa de datos para cierre de sesión.
// Aquí se toma la cadena de conexión desde appsettings.Development.json.
builder.Services.AddScoped<IDMCierreSesion>(provider =>
{
    var configuration = provider.GetRequiredService<IConfiguration>();

    var connectionString = configuration.GetConnectionString("DefaultConnection");

    if (string.IsNullOrWhiteSpace(connectionString))
    {
        throw new InvalidOperationException("No se encontró la cadena de conexión DefaultConnection.");
    }

    return new DMCierreSesion(connectionString);
});

// Registra la capa de negocio para cierre de sesión.
builder.Services.AddScoped<IBMCierreSesion, BMCierreSesion>();

// Registra la capa de datos para administración de empresas.
// Esta clase usa ADO.NET y ejecuta los procedimientos almacenados de la HU-005.
builder.Services.AddScoped<IDMEmpresas>(provider =>
{
    var configuration = provider.GetRequiredService<IConfiguration>();

    var connectionString = configuration.GetConnectionString("DefaultConnection");

    if (string.IsNullOrWhiteSpace(connectionString))
    {
        throw new InvalidOperationException("No se encontró la cadena de conexión DefaultConnection.");
    }

    return new DMEmpresas(connectionString);
});

// Registra la capa de negocio para administración de empresas.
builder.Services.AddScoped<IBMEmpresas, BMEmpresas>();

var app = builder.Build();

// Habilita Swagger solo en ambiente de desarrollo.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Redirige las peticiones HTTP hacia HTTPS.
app.UseHttpsRedirection();

// Habilita CORS antes de autorización.
app.UseCors("AngularPolicy");

// Habilita autorización en la API.
app.UseAuthorization();

// Mapea los controladores para que respondan las rutas tipo /api/...
app.MapControllers();

app.Run();