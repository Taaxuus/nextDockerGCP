# Wybierz obraz bazowy z Node.js
FROM node:20.8.1-alpine as builder

# Ustaw katalog roboczy w kontenerze
WORKDIR /app

# Skopiuj pliki package.json i package-lock.json do katalogu roboczego
COPY package*.json ./

# Zainstaluj zależności
RUN npm install --frozen-lockfile

# Skopiuj pozostałe pliki źródłowe aplikacji do katalogu roboczego
COPY . .

# Zbuduj aplikację Next.js
RUN npm run build

# Ewentualnie: Przygotuj etap produkcyjny z obrazem alpine
FROM node:20.8.1-alpine

# Ustaw katalog roboczy w kontenerze
WORKDIR /app

# Skopiuj tylko niezbędne pliki z etapu budowania
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Określ port, na którym nasłuchuje aplikacja
EXPOSE 3000

# Uruchom aplikację
CMD ["npm", "start"]
