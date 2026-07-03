using BMFacturacionIABack.CierreSesion;
using BMFacturacionIABack.Empresas;
using DMFacturacionIABack.CierreSesion;
using BMFacturacionIABack.UsuariosExternos;
using DMFacturacionIABack.UsuariosExternos;
using BMFacturacionIABack.Services;
using DMFacturacionIABack.Empresas;
using DMFacturacionIABack.Documentos;
using BMFacturacionIABack.Documentos;
using FacturacionIABack.Middleware;


var builder = WebApplication.CreateBuilder(args);

builder.WebHost.UseUrls("https://localhost:7066", "http://localhost:5062");

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

builder.Services.AddScoped<IDMUsuariosExternos>(provider =>
{
    var configuration = provider.GetRequiredService<IConfiguration>();

    var connectionString = configuration.GetConnectionString("DefaultConnection");

    if (string.IsNullOrWhiteSpace(connectionString))
    {
        throw new InvalidOperationException("No se encontró la cadena de conexión DefaultConnection.");
    }

    return new DMUsuariosExternos(connectionString);
});

builder.Services.AddScoped<IDMDocumentos>(provider =>
{
    var configuration = provider.GetRequiredService<IConfiguration>();

    var connectionString = configuration.GetConnectionString("DefaultConnection");

    if (string.IsNullOrWhiteSpace(connectionString))
    {
        throw new InvalidOperationException(
            "No se encontró la cadena de conexión DefaultConnection.");
    }

    return new DMDocumentos(connectionString);
});

// Registra la capa de negocio para cierre de sesión.
builder.Services.AddScoped<IBMCierreSesion, BMCierreSesion>();
builder.Services.AddScoped<IBMUsuariosExternos, BMUsuariosExternos>();
builder.Services.AddScoped<EmailService>();
builder.Services.AddScoped<IBMDocumentos, BMDocumentos>();
builder.Services.AddScoped<IFileStorageService, FileStorageService>();

builder.Services.AddHttpClient<ISecurityApiService, SecurityApiService>(
    (provider, client) =>
    {
        var configuration = provider.GetRequiredService<IConfiguration>();

        client.BaseAddress = new Uri(
            configuration["SecurityApi:BaseUrl"]!);
    });

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

app.UseMiddleware<ExceptionMiddleware>();

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