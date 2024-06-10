# Use the official .NET runtime image for Linux
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK image for Linux
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src
COPY ["dotnet-demo.csproj", "./"]
RUN dotnet restore "dotnet-demo.csproj"

# Copy everything else
COPY . .

# Build the project
WORKDIR "/src/."
RUN dotnet build "dotnet-demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet-demo.csproj" -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet-demo.dll"]
