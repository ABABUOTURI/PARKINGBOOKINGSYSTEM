Parking Booking System 🚗📱

A smart and efficient Parking Booking System built using Flutter. This system allows users to easily search, reserve, and manage parking slots in real-time, with added functionalities for admins and parking lot managers to manage availability and user feedback.
Table of Contents

    Features
    Screenshots
    Technologies Used
    Installation
    Usage
    Folder Structure
    Future Improvements
    Contributing
    License

Features 🎯
End Users (Drivers)

    Real-time Parking Availability: Check available parking slots in real-time.
    Search & Reserve: Search for parking by location, time, and duration. Reserve slots quickly and efficiently.
    Manage Reservations: Modify or cancel bookings.
    Notifications: Get notified about reservation status and expiry reminders.
    Payment Gateway: Pay for parking via multiple payment options.
    Feedback System: Submit feedback or complaints on your parking experience.

Admins & Parking Lot Managers

    Admin Dashboard: View and manage all reservations, slots, and user feedback.
    Real-Time Slot Management: Update and monitor parking slot availability dynamically.
    Reports & Analytics: View usage statistics, revenue, and occupancy rates.

Screenshots 🖼️

    Add some screenshots or GIFs here to visually showcase your app’s interface. You can include:

        Home screen
        Search parking map
        Booking screen
        Admin dashboard

Technologies Used 💻

    Flutter: The entire app is built using Flutter, providing cross-platform compatibility (Android/iOS).
    Firebase/Firestore: For real-time updates, database management, and user authentication.
    Google Maps API: For displaying parking locations and navigation.
    Stripe/PayPal: For handling secure online payments.
    Dart: The programming language used for Flutter development.

    Usage 🚀
User Login & Registration

    Users can sign up and log in using email and password or third-party authentication (Google, Apple).
    After logging in, they can view available parking spaces, reserve slots, and make payments.

Admin Dashboard

    Admins can manage parking slots, view reservations, and generate reports on parking activity and revenue.

Payments

    Payment integration allows users to securely pay for parking slots.

Folder Structure 📂

bash

lib/
│
├── models/           # Data models (User, ParkingSlot, Reservation, etc.)
├── screens/          # All UI pages (Home, Login, Parking Details, Admin Dashboard, etc.)
├── services/         # Firebase services, API calls, payment gateways
├── widgets/          # Reusable UI components (buttons, cards, forms)
├── utils/            # Helper classes and functions (validators, constants, etc.)
└── main.dart         # Main entry point of the app

Future Improvements 🚧

    Push Notifications: Implement push notifications for reservation updates and expiry reminders.
    Advanced Analytics: Provide admins with more detailed reports and analytics on parking usage.
    Geofencing: Notify users when they are near their reserved parking space.
    Multiple Language Support: Add localization to support multiple languages.


Theme color: 7671FA
             E5EAF3
             07244C
             7E7F9C

Font color: Lemon Milk

Frontend: Flutter
Backend:  Firebase
Payment Integration: Paypal/stripe
Real Time Data Management: Firebase...Real-Time database

PAGES = 18-19
User Type: 
    Drivers
    Admin
    Parking Manger

PAGES:
    DRIVERS;
        LOGIN PAGE;
            -Email/Phone No
            -Password
            -Login btn
            -Forgot password(link)
            -Register (link)
        REGISTRATION PAGE;
            -Name(Full Name)
            -Email
            -Phone Number
            -Password
            -Confirm Password
            -Register btn
            -Login(link)
        DASHBOARD PAGE;
            -Greetings with Name
            -Search Bar
            -Map View
            -List View of Available Parking
            -Quick Actions:
                -Book Parking
                -View Booking
                -Payment History
                -Profile
        SEARCH FOR PARKING PAGE;
            -Location Search Bar
            -Filter Option;
                -Distance
                -Price Range
                -Parking Type
                -Parking Duration
            -Results List/Map View
                -Parking Name/Location
                -Availability(Real-Time)
                -Price per hour/day
                -Book Now Btn
        RESERVATION MANAGEMENT PAGE;
            -Components
                -Upcoming Bookings
                -Past Bookings
                -Modify Booking Btn
                -Cancel Booking Btn
        BOOKING DETAILS PAGE;
            -Fields
                -Parking Spot Location Name
                -Date and Time of Booking
                -Parking Space Type
                -Price Calculation
                -Confirm Booking Btn
                -Booking Confirmation Details

    DRIVERS & ADMIN
    DRIVERS
        PARKING AVAILABILITY MAP PAGE;
            -Components
                -Interact Map
                -Parking Markers
                -Search for location
                -Filter Options
                -Select a parking Space
        RESERVATION MANAGEMNET PAGE;
        BOOKING HISTORY:
            -Components
                -List of Past Bookings
                -Booking Details
                -Rebook Btn
        MODIFY/CANCEL BOOKING:
            -Booking Information
            -Edit Time/Date Option
            -Cancel Booking Btn
    ADMIN
        PARKING AVAILABILITY CONTROL PAGE;
            -Components
                -Parking Location List
                -Parking Slots Count
                -Add/Edit Slots
                -Real-Time updates
        RESERVATION MANAGEMENT PAGE;
            -View User Reservations
            -Search by user or location
            -Modify Reservation Btn
            -Cancel Reservation 
    DRIVERS & PARKING OWNERS
    DRIVERS
        PAYMENT OPTIONS PAGE;
            -Payment Method
                -Credit/Debit Card
                -Mobile Payment
                -Paypal Option
            -Billing Address
            -Review Payment Details
            -Submit Payment Btn
        PAYMENT CONFIRMATION PAGE;
            -Confirmation of payment
            -Receipt download
            -Booking ID/ Transaction ID
            -Booking summary Btn
    PARKING OWNERS
        PAYMENT REPORTS PAGE;
            -Daily/Weekly/Monthly Reports
            -Transaction Details
            -Export Report Btn
    DRIVERS/ADMINS/PARKING OWNERS
    DRIVERS
        SUBMIT FEEDBACK PAGE;
            -Ratings
            -Comments
            -Parking LOcations Dropdown
            -Submit Btn
    ADMIN & PARKING OWNERS
        FEEDBACK REVIEW PAGE;
            -View submitted Feedback
            -Filter by Rating or Location
            -Mark Feedback as Resovled
            -Export feedback Report
        ADMIN LOGIN PAGE;
            -Admin Email
            -Password
            -Login Btn
            -link
        ADMIN DASHBOARD PAGE;
            -Overview of current Reservations
            -Revenue Overview
            -Parking Slot Utilization
            -Quick Links
                -Mange parking slot
                -View feedback
                -User management
                -Payment Report
        PARKING SLOT MANAGEMENT PAGE;
            -List of parking Locations
            -Add/Edit Slots Btn
            -Parking Slot Status
            -Edit Parking Details



