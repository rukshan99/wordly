# wordly

“Wordly” is a quiz-based word guessing game developed as a mobile app. The app was developed using Flutter and Firebase.

A normal user can create an account and answer quizzes. In the quizzes, the user needs to select the correct answer(s) for the given definition. User will earn points based on the number of right answers in a quiz and the points will be added to user’s total points in the system. There is a leaderboard where the users can see their rank based on their total points among all the other active users. Users can use their profile to view their details and total points they have earned. Users can use this to edit their details too.  Also, users can always add reviews to give feedback about the app.

Admins can add word definitions and answers to the database through the app. One word definition has four answers, where one or multiple of them can be right. Admins can make normal users Admins or delete them. Admins can also view all the user feedback.

## Functions
- [x] Login and register with Firebase Authentication
- [x] Add user details to the “users” collection in Cloud Firestore
- [x] Display registered users list
- [x] Change a normal user to an Admin user
- [x] Delete user
- [x] Display a user leaderboard

