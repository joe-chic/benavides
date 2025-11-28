# Farmacias Benavides - Android App

Android application for Farmacias Benavides built with Kotlin.

## Features

- **Login Screen**: User authentication with email and password
- **Create Account Screen**: New user registration
- **Reset Password Screen**: Password recovery via email
- **JWT Authentication**: Secure token-based authentication
- **API Integration**: Connected to FastAPI clinical service

## Setup

### Prerequisites

- Android Studio (latest version)
- Android SDK 24+ (minimum)
- Kotlin 1.9.24+

### Configuration

1. **API Base URL**: Update `RetrofitClient.kt` if your API is not running on `http://10.0.2.2:8000`
   - For Android Emulator: Use `10.0.2.2` to access `localhost` on your host machine
   - For Physical Device: Use your computer's IP address (e.g., `http://192.168.1.100:8000`)

2. **Fonts**: Add Nunito font files to `app/src/main/res/font/`:
   - `nunito_bold.ttf`
   - `nunito_regular.ttf`
   - `nunito_extrabold.ttf`
   
   Download from: https://fonts.google.com/specimen/Nunito

3. **Logo**: Add the Benavides logo image to `app/src/main/res/drawable/` as `logo_benavides.png`
   - Update `activity_login.xml` and `activity_reset_password.xml` to reference the logo

## Project Structure

```
app/src/main/
├── java/jonathan/humphreys/benavidesapp/
│   ├── data/
│   │   ├── api/
│   │   │   ├── AuthApiService.kt
│   │   │   └── RetrofitClient.kt
│   │   └── model/
│   │       └── AuthModels.kt
│   ├── ui/
│   │   ├── login/
│   │   │   └── LoginActivity.kt
│   │   ├── createaccount/
│   │   │   └── CreateAccountActivity.kt
│   │   └── resetpassword/
│   │       └── ResetPasswordActivity.kt
│   └── util/
│       └── SharedPreferencesHelper.kt
└── res/
    ├── layout/
    │   ├── activity_login.xml
    │   ├── activity_create_account.xml
    │   └── activity_reset_password.xml
    ├── values/
    │   ├── colors.xml
    │   ├── strings.xml
    │   ├── dimens.xml
    │   └── styles.xml
    └── font/
        ├── nunito_bold.xml
        ├── nunito_regular.xml
        └── nunito_extrabold.xml
```

## API Integration

The app connects to the FastAPI clinical service running on:
- **Development**: `http://10.0.2.2:8000/api/v1/`
- **Production**: Update `RetrofitClient.BASE_URL`

### Endpoints Used

- `POST /auth/login` - User login
- `POST /auth/refresh` - Refresh access token
- `GET /auth/me` - Get current user info

### Authentication Flow

1. User enters credentials
2. App sends login request to API
3. API returns access token and refresh token
4. Tokens are stored in SharedPreferences
5. Access token is used for authenticated requests
6. Refresh token is used to get new access token when expired

## Testing

### Running the App

1. Start the FastAPI service: `docker-compose up` (from project root)
2. Open project in Android Studio
3. Run the app on an emulator or device
4. The app will start with the Login screen

### Test Credentials

Use the dummy data from the database:
- Username: `dr.garcia` (or any user from dummy data)
- Password: Any password (base implementation accepts any password for existing users)

## Notes

- **Base Implementation**: This is a base implementation as requested. Some features are placeholders:
  - Create Account API endpoint needs to be implemented in the backend
  - Reset Password API endpoint needs to be implemented in the backend
  - Password verification is currently disabled (accepts any password for existing users)

- **Fonts**: Currently using system fonts as fallback. Add Nunito font files for exact design match.

- **Logo**: Add the Benavides logo image to match the Figma design.

## Next Steps

1. Add Nunito font files
2. Add Benavides logo image
3. Implement create account API endpoint in backend
4. Implement reset password API endpoint in backend
5. Add proper password verification
6. Implement main activity after login
7. Add role-based navigation

