# magicai_workout
Magic Tracker is a Flutter application designed to help users plan and track their workouts. The app provides features such as adding,
updating, and deleting workouts, as well as viewing weekly summaries of workout statistics.

# Architectural Choices and Third-Party Packages

## Architectural Choices

### 1. Flutter Framework
We chose Flutter as our primary framework for building the `magic_tracker` application. Flutter allows us to create natively compiled applications for mobile, web, and desktop from a single codebase. This significantly reduces development time and ensures a consistent user experience across all platforms.

### 2. State Management
We use the `provider` package for state management. `provider` is a simple and efficient way to manage state in Flutter applications. It allows us to separate business logic from UI code, making the app more modular and easier to maintain.

### 3. Dependency Injection
`provider` also serves as our dependency injection framework. This allows us to inject dependencies into our widgets, making the code more testable and easier to manage.

### 4. Internationalization
We use the `intl` package to handle internationalization. This package provides a simple way to format dates, numbers, and currencies, and to manage localized messages. This is crucial for making our app accessible to a global audience.

### 5. Animation
The `lottie` package is used for animations. Lottie allows us to use animations created in Adobe After Effects in our Flutter app. This enhances the user experience by providing smooth and visually appealing animations.

### 6. Shared Preferences
We use the `shared_preferences` package to store simple data persistently. This is useful for storing user settings and preferences, which need to be retained across app launches.

## Third-Party Packages

### 1. `provider`
- **Reasoning**: Simplifies state management and dependency injection.
- **Usage**: Used to manage the state of the application and inject dependencies into widgets.

### 2. `intl`
- **Reasoning**: Provides internationalization and localization support.
- **Usage**: Used to format dates, numbers, and currencies, and to manage localized messages.

### 3. `lottie`
- **Reasoning**: Allows the use of high-quality animations created in Adobe After Effects.
- **Usage**: Used to display animations in the app, enhancing the user experience.

### 4. `shared_preferences`
- **Reasoning**: Provides a simple way to store data persistently.
- **Usage**: Used to store user settings and preferences.

## Conclusion
The architectural choices and third-party packages used in the `magic_tracker` application are aimed at creating a robust, maintainable, and user-friendly application. By leveraging Flutter's capabilities and carefully selected packages, we ensure a high-quality experience for our users across all platforms.

