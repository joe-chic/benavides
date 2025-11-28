# Test Credentials for Login

## Available Test Users

Based on the dummy data in the database, you can use any of these usernames to test the login functionality:

### Medical Staff (Medics)
- **Email**: `dr.garcia@farmaciasbenavides.com.mx`
- **Display Name**: Dr. Carlos García López
- **Password**: Any password (base implementation accepts any password for existing users)

- **Email**: `dra.martinez@farmaciasbenavides.com.mx`
- **Display Name**: Dra. Ana Martínez Rodríguez
- **Password**: Any password

- **Email**: `dr.hernandez@farmaciasbenavides.com.mx`
- **Display Name**: Dr. Luis Hernández Pérez
- **Password**: Any password

### Administrator
- **Email**: `admin@farmaciasbenavides.com.mx`
- **Display Name**: Administrador Sistema
- **Password**: Any password

### Recepcionists
- **Email**: `recepcion.mty@farmaciasbenavides.com.mx`
- **Display Name**: María González
- **Password**: Any password

- **Email**: `recepcion.cdmx@farmaciasbenavides.com.mx`
- **Display Name**: Patricia Ramírez
- **Password**: Any password

### Pharmaceutics
- **Email**: `farm.jimenez@farmaciasbenavides.com.mx`
- **Display Name**: Farmacéutico Roberto Jiménez
- **Password**: Any password

- **Email**: `farm.torres@farmaciasbenavides.com.mx`
- **Display Name**: Farmacéutica Laura Torres
- **Password**: Any password

### Patients
- **Email**: `juan.perez@email.com`
- **Display Name**: Juan Pérez García
- **Password**: Any password (base implementation accepts any password for existing users)

- **Email**: `maria.rodriguez@email.com`
- **Display Name**: María Rodríguez López
- **Password**: Any password

- **Email**: `roberto.fernandez@email.com`
- **Display Name**: Roberto Fernández Morales
- **Password**: Any password

- **Email**: `ana.sanchez@email.com`
- **Display Name**: Ana Sánchez González
- **Password**: Any password

- **Email**: `carlos.moreno@email.com`
- **Display Name**: Carlos Moreno Díaz
- **Password**: Any password

## Recommended Test Credentials

**For testing patient home view (recommended):**
- **Email**: `juan.perez@email.com` ← Patient account
- **Password**: `test123` (or any password - base implementation)

**For testing other roles:**
- **Email**: `dr.garcia@farmaciasbenavides.com.mx` ← Medic account
- **Password**: `test123` (or any password - base implementation)

**Note**: The app now uses email-based login. Enter the full email address in the email field.
- **Patient accounts** will navigate to the Patient Home view
- **Other role accounts** will show a placeholder message (not yet implemented)

## Notes

⚠️ **Important**: This is a base implementation. The login currently:
- Accepts any password for existing users (password verification is disabled)
- Validates that the email exists in the database
- Returns JWT tokens on successful login
- Uses email-based authentication (not username)

For production, you'll need to:
- Implement proper password hashing/verification
- Add password strength requirements
- Add account lockout after failed attempts
- Add rate limiting

## Testing Steps

1. Make sure the backend is running: `docker-compose up`
2. Verify API is accessible: http://localhost:8000/docs
3. Run the Android app
4. **In the Email field**, enter: `dr.garcia@farmaciasbenavides.com.mx`
5. Enter any password (e.g., `test123`)
6. Click "Iniciar sesión"
7. You should see a success message and tokens will be stored

**Important**: Enter the full email address in the email field. The app now uses email-based authentication.

## Expected Behavior

- ✅ **Success**: Shows "Inicio de sesión exitoso" toast, stores tokens
- ❌ **User not found**: Shows "Error al iniciar sesión. Verifica tus credenciales."
- ❌ **Network error**: Shows "Error de conexión. Verifica tu internet."
- ❌ **Invalid email format**: Shows validation error on email field
- ❌ **Empty fields**: Shows validation errors on empty fields

