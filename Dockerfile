FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY ["MyTM/MyTM.csproj", "MyTM/"]
RUN dotnet restore "MyTM/MyTM.csproj"

# Copy rest and publish
COPY . .
RUN dotnet publish "MyTM/MyTM.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
ENV ASPNETCORE_URLS=http://+:$PORT
ENTRYPOINT ["dotnet", "MyTM.dll"]
