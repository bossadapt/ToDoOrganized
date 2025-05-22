
# To Do Organized

**To Do Organized** is a self-hostable Ruby on Rails application for managing shared to-do lists in real time. You can try a demo on my [website](https://bossadapt.org/todoorganized/).

This app supports real-time collaboration through Turbo Streams (websockets), allowing users to see updates, comments, and changes as they happen. It also includes an action history log that provides accountability by recording all modifications to projects and entries — none of which can be deleted.

[![Demo Video](https://i.ytimg.com/vi/MvMJa6k0ogg/hqdefault.jpg)](https://youtu.be/MvMJa6k0ogg)


> **Note:** The public demo is provided for testing purposes only. There are no guarantees regarding uptime or data integrity. For reliable use, consider hosting your own instance.

---

## 💡 UI Design (Initial)

The initial UI was drafted on Figma:
![UI Design](https://github.com/user-attachments/assets/11813a9e-ec20-4705-8ab5-2da518f8f56c)

Since then, the interface has evolved significantly.

---

## 🗃️ Database Design (Initial)

Original database schema created using dbdiagram.io:
![Database Design](https://github.com/user-attachments/assets/919d4e71-036c-4f2d-bde3-f2f8d3417962)

The core data model consists of five interconnected entities:

* **Users**
* **Projects**
* **Project Entries**
* **Comments**
* **Actions (for change tracking)**

---

## 🚧 Current Limitations & Areas for Improvement

These are features that are currently missing or could use enhancement. Ideal areas of focus for forks or pull requests:
* Devise settings for more secure measures(Email Verification, Password Resets and email changes)
* Support for multiple assignees per task
* Improved mobile interface
* Filtering capabilities for comments, project entries, and action history
* Smarter pagination that doesn't reset users to page 1 on updates
* Integration of comments into the action history to use it as a notification system
