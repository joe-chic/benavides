# Android App Setup Notes

## Required Assets

### 1. Fonts
Download Nunito font family from Google Fonts and add to `app/src/main/res/font/`:
- `Nunito-Bold.ttf` → rename to `nunito_bold.ttf`
- `Nunito-Regular.ttf` → rename to `nunito_regular.ttf`
- `Nunito-ExtraBold.ttf` → rename to `nunito_extrabold.ttf`

After adding fonts, update the font XML files to reference them properly.

### 2. Logo
Add the Benavides logo image to `app/src/main/res/drawable/` as `logo_benavides.png` or `logo_benavides.jpg`.

Then update:
- `activity_login.xml` - Set `android:src="@drawable/logo_benavides"` on logoImageView
- `activity_reset_password.xml` - Set `android:src="@drawable/logo_benavides"` on logoImageView

## API Configuration

### For Android Emulator
The app is configured to use `http://10.0.2.2:8000` which maps to `localhost:8000` on your host machine.

### For Physical Device
1. Find your computer's IP address (e.g., `192.168.1.100`)
2. Update `RetrofitClient.kt`:
   ```kotlin
   private const val BASE_URL = "http://192.168.1.100:8000/api/v1/"
   ```
3. Make sure your device and computer are on the same network
4. Ensure firewall allows connections on port 8000

## Testing

1. Start the backend: `docker-compose up` (from project root)
2. Verify API is running: http://localhost:8000/docs
3. Run the Android app
4. Test login with: `dr.garcia` (or any username from dummy data)

## Known TODOs

- [ ] Add Nunito font files
- [ ] Add Benavides logo image
- [ ] Implement create account API endpoint in backend
- [ ] Implement reset password API endpoint in backend
- [ ] Add proper password hashing/verification
- [ ] Implement main activity after successful login
- [ ] Add token refresh logic on 401 responses
- [ ] Add network connectivity checks

