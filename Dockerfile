#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src
COPY ["DockerIntegration/DockerIntegration/DockerIntegration.csproj", "DockerIntegration/"]
RUN dotnet restore "DockerIntegration/DockerIntegration/DockerIntegration.csproj"
COPY . .
WORKDIR "/src/DockerIntegration"
RUN dotnet build "DockerIntegration.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerIntegration.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerIntegration.dll"]


