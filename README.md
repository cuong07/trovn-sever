# TROVN Server

TROVN is a comprehensive room rental platform API server built with Node.js, Express.js, and Prisma ORM. The platform connects property owners (hosts) with tenants, providing features for property listings, appointment scheduling, rental management, payments, and communication.

## 🏗️ Architecture

### Tech Stack

- **Runtime**: Node.js 20+
- **Framework**: Express.js
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: JWT + Passport.js (Google OAuth)
- **File Storage**: Cloudinary
- **Caching**: Redis
- **Real-time Communication**: Socket.IO
- **Email Service**: Nodemailer
- **Payment Integration**: MoMo, VNPay, Zalo Pay
- **Image Processing**: Sharp, Azure Computer Vision
- **Task Scheduling**: Node-cron

### Key Features

- 🏠 **Property Management**: Create, update, and manage rental listings
- 📅 **Appointment Scheduling**: Book and manage property viewing appointments
- 💰 **Payment Processing**: Integrated payment gateways (MoMo, VNPay, Zalo)
- 💬 **Real-time Messaging**: Socket.IO powered chat system
- 🔍 **Smart Search**: Location-based search with recommendations
- 📊 **Analytics Dashboard**: Revenue and property analytics for hosts
- 📱 **Mobile Support**: RESTful API optimized for mobile applications
- 🔐 **Authentication**: JWT-based auth with OAuth integration
- 📧 **Email Notifications**: Automated email notifications for bookings
- ⭐ **Review System**: Property rating and review management

## 🚀 Quick Start

### Prerequisites

- Node.js 20 or higher
- PostgreSQL database
- Redis server
- Cloudinary account
- Email service (SMTP)

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd tro-server
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Environment Setup**

   ```bash
   cp .env.example .env
   ```

   Configure your environment variables in `.env`:

   ```bash
   # Database
   DATABASE_URL="postgresql://username:password@localhost:5432/trovn"

   # Server
   PORT=8891
   APP_NAME="TROVN"

   # Authentication
   SECRET_KEY="your-jwt-secret"
   SECRET_REFRESHTOKEN_KEY="your-refresh-token-secret"

   # Google OAuth
   CLIENT_ID="your-google-client-id"
   CLIENT_SECRET="your-google-client-secret"

   # Cloudinary
   CLOUDINARY_KEY="your-cloudinary-key"
   CLOUDINARY_SECRET="your-cloudinary-secret"
   CLOUDINARY_NAME="your-cloudinary-name"

   # Redis
   REDIS_HOST="localhost"
   REDIS_PORT=6379
   REDIS_PASSWORD=""
   USE_REDIS_CACHE=true
   REDIS_CACHE_EXPIRATION=3600

   # Email Configuration
   MAIL_HOST="smtp.gmail.com"
   MAIL_PORT=587
   MAIL_USERNAME="your-email@gmail.com"
   MAIL_PASSWORD="your-app-password"
   MAIL_FROM_ADDRESS="noreply@trovn.io.vn"
   MAIL_FROM_NAME="TROVN"

   # Payment Gateways
   MOMO_ACCESS_KEY="your-momo-access-key"
   MOMO_SECRET_KEY="your-momo-secret-key"

   # Azure Computer Vision
   AZURE_COMPUTER_VISION_API_KEY="your-azure-key"
   ```

4. **Database Setup**

   ```bash
   # Generate Prisma client
   npx prisma generate

   # Run database migrations
   npx prisma db push

   # (Optional) Seed database
   npx prisma db seed
   ```

5. **Start the server**

   ```bash
   # Development mode with hot reload
   npm start

   # Production mode
   node index.js
   ```

The server will start on `http://localhost:8891`

## 📚 API Documentation

### Base URL

```
https://api.trovn.io.vn/api/v1
```

### Authentication

The API uses JWT authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

### Core Endpoints

#### Authentication

- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `POST /auth/refresh` - Refresh JWT token
- `GET /auth/google` - Google OAuth login

#### Property Listings

- `GET /listings` - Get property listings with filters
- `POST /listing` - Create new property listing
- `GET /listing/:id` - Get property details
- `PUT /listing/:id` - Update property listing
- `DELETE /listing/:id` - Delete property listing
- `GET /listings/recommendations` - Get personalized recommendations

#### Appointments

- `POST /appointment` - Book property viewing
- `GET /appointments` - Get user appointments
- `PUT /appointment/:id` - Update appointment status
- `DELETE /appointment/:id` - Cancel appointment

#### Rental Management

- `GET /rented-rooms/host` - Get rooms rented by host
- `GET /rented-rooms/user` - Get user's rented rooms
- `PUT /rented-rooms/:id` - Update rental status
- `DELETE /rented-rooms/:id` - End rental agreement

#### Reviews

- `POST /review` - Create property review
- `GET /reviews/:listingId` - Get property reviews
- `PUT /review/:id` - Update review
- `DELETE /review/:id` - Delete review

#### Payments

- `POST /payment/momo` - Process MoMo payment
- `POST /payment/vnpay` - Process VNPay payment
- `GET /invoices` - Get payment invoices
- `GET /transaction-history` - Get transaction history

#### Messaging

- `GET /conversations` - Get user conversations
- `POST /conversation` - Start new conversation
- `GET /conversation/:id/messages` - Get conversation messages

## 🏛️ Database Schema

### Core Models

#### User

- Authentication and profile information
- Roles: USER, HOST, ADMIN
- Location and contact details

#### Listing

- Property information (title, description, price, area)
- Location coordinates for mapping
- Amenities and features
- Image gallery
- Availability status

#### RentedRoom

- Rental agreements between hosts and tenants
- Rental status tracking
- Payment information

#### Appointment

- Property viewing appointments
- Status management (PENDING, CONFIRMED, DONE, CANCELED)
- Email notifications

#### Review

- Property ratings and reviews
- Linked to confirmed rentals

## 🐳 Deployment

### Docker Deployment

```bash
# Build Docker image
docker build -t trovn-server .

# Run container
docker run -p 8891:8891 -e DATABASE_URL="your-db-url" trovn-server
```

### Vercel Deployment

The project is configured for Vercel deployment with `vercel.json`. Simply connect your repository to Vercel.

### Environment Variables for Production

Ensure all environment variables are properly configured in your hosting platform:

- Database connection strings
- API keys and secrets
- CORS origins
- Redis configuration

## 🔧 Development

### Project Structure

```
├── config/           # Configuration files (database, auth, etc.)
├── controllers/      # Route controllers
├── core/            # Core business logic
├── enums/           # TypeScript-like enums
├── jobs/            # Background jobs and cron tasks
├── lib/             # Database connection
├── middlewares/     # Express middlewares
├── models/          # Prisma model methods
├── prisma/          # Database schema and migrations
├── responses/       # Response formatters
├── routes/          # API route definitions
├── services/        # Business logic services
├── socket/          # Socket.IO configuration
├── utils/           # Utility functions
├── validate/        # Input validation schemas
└── webhook/         # Payment webhook handlers
```

### Available Scripts

- `npm start` - Start development server with hot reload
- `npm run build` - Build for production
- `npm test` - Run tests (placeholder)
- `npm run postinstall` - Generate Prisma client

### Development Guidelines

1. Follow RESTful API conventions
2. Use proper HTTP status codes
3. Implement proper error handling
4. Add input validation for all endpoints
5. Use transactions for data consistency
6. Implement proper logging
7. Cache frequently accessed data

## 📄 License

This project is licensed under the ISC License.

## 📞 Support

For support and inquiries:

- Email: support@trovn.io.vn
- Website: https://trovn.io.vn

## 🔗 Related Projects

- **TROVN Zalo Mini App** - Software as a service on Zalo
- **TROVN Admin Dashboard** - Administrative interface
- **TROVN Frontend** - Web application frontend

---

**TROVN** - Making room rental simple and secure 🏠
