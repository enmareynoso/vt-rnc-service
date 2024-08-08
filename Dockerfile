FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Octetus.ConsultasDgii.WebAPI/Octetus.ConsultasDgii.WebAPI.csproj", "Octetus.ConsultasDgii.WebAPI/"]
COPY ["Octetus.ConsultasDgii/Octetus.ConsultasDgii.csproj", "Octetus.ConsultasDgii/"]
RUN dotnet restore "Octetus.ConsultasDgii.WebAPI/Octetus.ConsultasDgii.WebAPI.csproj"
COPY . .
WORKDIR "/src/Octetus.ConsultasDgii.WebAPI"
RUN dotnet build "Octetus.ConsultasDgii.WebAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Octetus.ConsultasDgii.WebAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Octetus.ConsultasDgii.WebAPI.dll"]
