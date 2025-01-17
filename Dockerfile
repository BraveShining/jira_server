#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 5000
EXPOSE 5001
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Jira_server.csproj", "."]
RUN dotnet restore "./Jira_server.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Jira_server.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Jira_server.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Jira_server.dll"]