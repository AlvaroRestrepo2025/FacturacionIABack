var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// Permite usar controladores API.
builder.Services.AddControllers();

// Configura Swagger para documentar y probar los endpoints de la API.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.

// Habilita Swagger solo en ambiente de desarrollo.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Redirige las peticiones HTTP hacia HTTPS.
app.UseHttpsRedirection();

// Habilita autorización en la API.
app.UseAuthorization();

// Mapea los controladores para que respondan las rutas tipo /api/...
app.MapControllers();

app.Run();