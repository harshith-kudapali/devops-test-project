# Stage 1: Build the React frontend
FROM node:16 as frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/inventory_management_system ./
RUN npm run build

# Stage 2: Set up the Node backend
FROM node:16 as backend
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ ./

# Copy the built frontend from Stage 1 to the backend server's static files directory
COPY --from=frontend /app/frontend/build /app/backend/public

# Define environment variables (optional, if needed for MongoDB)
ENV PORT=5000
EXPOSE 5000

CMD [ "node", "server.js" ]
