FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# copy csproj and restore first for better cache
COPY ["MyTM.csproj", "./"]
RUN dotnet restore "./MyTM.csproj"

# copy the rest and publish
COPY . .
RUN dotnet publish "MyTM.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80

# Use the PORT env provided by Render; dotnet CLI --urls will bind to it
ENTRYPOINT ["sh", "-c", "dotnet MyTM.dll --urls http://*:$PORT"]
