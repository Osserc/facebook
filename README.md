# README

This is my submission for TOP's Ruby on Rails course crowning jewel: building Facebook! For more information, take a look here: https://www.theodinproject.com/lessons/ruby-on-rails-rails-final-project

At its base, MonkeBook is a relationship platform: users can post messages, comment on them, send fried requests and either accept them or deny them. This was easy enough to implement, since all these are pretty straightforward database relationships.
The first complication was laying the groundwork for allowing users to either post a text or an image as a post; to solve this problem I found out about delegated types. They served my purposes really well, but due to the way I implemented it I could not take advantage of Rails' form autocompletion, and I had to devise a workaround in the view.  
The discovery of delegated types also served me well when creating the notification system, where users can receive reminders of other users' activity.
Speaking of which, I went beyond specs and implemented a following system as well as a blocking system. The code is pretty self-explanatory, but what I want to stress is that the logic in the blocking controller had to check whether or not the users were in other relationships, and to delete them in case they were (for example, blocking a user should remove your friends status).  
Next were likes. Since you could like both posts and comments, a polymorphic association was perfect.
At this point, all that was left was the notification system, which underwent a number of significant changes before settling for its current form. The most important differences from earlier implementations are the moving of the notification deletion logic from the controllers to the models, through callbacks; a smarter and more streamlined notification message composition method, based on notifiable_types and a couple of values; and an anti-spam system for easily spammable notifications, like followings.  
Then came the user personalization, namely the possibility of including a small biography and a custom avatar. Since I wanted to have default values, I elected to associate a profile model to the user model, and operate on that without generating the devise controllers. Since the profile creation was automated through a callback after user creation, I had to separate the action into _build and _save commands to avoid an endless loop.
Now, all features are complete. What was left was creating adequate views to host all this functionality.

My design was achieved mainly through the magic of TurboFrames and TurboStreams. I am especially proud of my homepage, with recurring users updating at the same time through smart TurboStreams. This turbo functionality was a blast to work with, and was more than enough to accomplish what I wanted; CSS than did the rest.
There was only one blemish though: the post editing functionality. For a long time I was stuck with replacing the whole post, and leaving the edit button outside of the frame, nonfunctional. This gave me the push I needed to delve into StimulusJS, which I successfully used to "swap" the edit and close buttons, fulfilling my desired design.

This little foray into Stimulus helped me greatly when it came to adapting views for mobile devices. While some views could be simply converted to vertical flexbox layouts, others necessitated multiple pages. Enter Stimulus. My solution was implementing buttons at the top of the view to programmatically hide and reveal different parts of the views. Of interest is also the disappearance of the navbar, and its relocation to the side, to be opened by clicking on a thin ribbon.

All in all, this project taught me many things and gave me a great deal of confidence in tackling huge projects and delving into documentation on my own. I am glad this was included in the Odin project: it might not be revolutionary in terms of technologies, but it gave me the chance to work on some aspects of Rails I was not overly familiar with and making them all play nice with each other.

Live preview: https://monkebook.herokuapp.com/
To see the website for yourself without making a new account, use the following:  
Email: user1@proton.com  
Password: 123456

# Credits

Background from <a href="https://www.pexels.com/@matheusnatan/">Matheus Natan</a>  
Primates images from random memes on the web