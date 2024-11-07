# Stage 1: Build the React frontend
FROM node:16 AS frontend
WORKDIR /app/frontend

# Copy package.json and install dependencies
COPY frontend/package*.json ./
RUN npm install

# Copy the rest of the frontend files and build the React app
COPY frontend/ ./
RUN npm run build

# Stage 2: Set up the Node backend
FROM node:16 AS backend
WORKDIR /app/backend

# Copy package.json and install dependencies
COPY backend/package*.json ./
RUN npm install

# Copy the backend source code
COPY backend/ ./

# Copy the built frontend from Stage 1 to the backend server's static files directory
COPY --from=frontend /app/frontend/build /app/backend/public

# Define environment variables (optional, if needed for MongoDB)
ENV PORT=5000
EXPOSE 5000

# Start the Node.js server
CMD ["node", "server.js"]
