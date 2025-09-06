# PingMyRide - Firebase Authentication Setup

## Role-Based Authentication System

This application now uses Firebase Authentication with Cloud Firestore for role-based user management.

### User Roles

1. **Admin** - Full system access and management capabilities
2. **Driver** - Bus operations and route management
3. **Student** - Booking and tracking services

### Database Structure

The application uses Cloud Firestore with the following structure:

```
/users/{userId}
├── uid: string
├── email: string
├── username: string
├── role: "admin" | "driver" | "student"
├── createdAt: timestamp
└── isActive: boolean
```

### Available Test Accounts

The app automatically creates the following test accounts for easy testing:

#### 🔑 **Primary Test Accounts**
| Role | Email | Password | Username |
|------|-------|----------|----------|
| Admin | admin@test.com | admin123 | Test Admin |
| Driver | driver@test.com | driver123 | Test Driver |
| Student | student@test.com | student123 | Test Student |

#### 🔑 **Additional Test Accounts**

**Admin Accounts:**
- admin1@pingmyride.com / admin123 (John Admin)
- admin2@pingmyride.com / admin456 (Sarah Manager)

**Driver Accounts:**
- driver1@pingmyride.com / driver123 (Mike Driver)
- driver2@pingmyride.com / driver456 (Lisa Transport)
- driver3@pingmyride.com / driver789 (Carlos Rodriguez)

**Student Accounts:**
- student1@pingmyride.com / student123 (Emma Student)
- student2@pingmyride.com / student456 (Alex Johnson)
- student3@pingmyride.com / student789 (Sophia Chen)
- student4@pingmyride.com / student101 (David Wilson)
- student5@pingmyride.com / student202 (Maya Patel)

### Features Implemented

✅ **Firebase Authentication Integration**
- Email/password authentication
- Role-based user registration
- Secure login with role validation

✅ **Role Validation System**
- Prevents users from logging into wrong role portals
- Clear error messages for role mismatches
- Automatic logout on role validation failure

✅ **Account Management**
- Admin panel to create new accounts
- View all existing accounts with filtering
- Pre-created test accounts for immediate testing

✅ **Enhanced Login Experience**
- Test credentials display for easy access
- One-tap credential auto-fill
- Role-specific UI theming

✅ **Firestore Database**
- User profile storage
- Role-based access control
- User management system

✅ **Security Features**
- Role validation on login
- Secure password requirements
- Email validation
- Firestore security rules

### How to Use Test Accounts

1. **Run the app**: All test accounts are automatically created
2. **Select your role**: Choose Admin, Driver, or Student
3. **Login screen**: 
   - See test credentials displayed at bottom
   - Tap credentials to auto-fill login form
   - Or manually enter any account from the list above
4. **Role validation**: System prevents cross-role login attempts

### Admin Features

**Account Management:**
- **Create Account**: Add new users with any role
- **View Accounts**: See all registered users with filtering options
- Access through Admin dashboard after login

### Authentication Flow

1. User selects their role (Admin/Driver/Student)
2. System shows role-specific login screen with test credentials
3. User can tap test credentials to auto-fill or enter manually
4. System validates credentials AND role match
5. If role doesn't match: Clear error message + automatic logout
6. If successful: Role-based navigation to appropriate dashboard

### Error Handling

- **Role Mismatch**: "Role mismatch: This account is registered as [Role], but you tried to login as [Role]"
- **Invalid Credentials**: "Login failed. Please check your credentials."
- **Registration Issues**: "Registration failed. Email may already be in use."

### Firebase Setup Required

Make sure you have:
1. ✅ Firebase project configured
2. ✅ Authentication enabled (Email/Password)
3. ✅ Cloud Firestore database created
4. ✅ Firebase configuration files added
5. ✅ Firestore security rules configured

### Quick Start

1. Run the app: `flutter run`
2. Wait for test accounts to be created (shown in console)
3. Select any role on welcome screen
4. Tap the test credentials to auto-login
5. Explore role-specific features
6. Use logout button in profile to switch accounts

### Development Notes

- All test accounts are created automatically on first run
- Console logs show account creation progress
- Admin panel allows creating additional custom accounts
- Role validation prevents unauthorized access across roles
