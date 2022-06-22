# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# useful methods

def friends?(user, current_user)
    user.friends.include?(current_user)
end

def requested?(user, current_user)
    user.sent_requests.exists?(receiver: current_user)
end

def find_request(user, current_user)
    user.requests.select { | request | request.sender == current_user || request.receiver == current_user }.first
end

def find_friendship(user, current_user)
    user.friendships.select { | friendship | friendship.friend_one == current_user || friendship.friend_two == current_user }.first
end

def find_blocking(user, current_user)
    user.blocked_by.find_by(blocker: current_user)
end

def clear_follow_relations(user, current_user)
    Following.where(follower: user, follow: current_user).or(Following.where(follower: current_user, follow: user)).destroy_all
end

def find_following(user, current_user)
    user.followed_people.find_by(follow: current_user)
end

def find_follower(user, current_user)
    user.following_people.find_by(follower: current_user)
end

def find_like(type, id, current_user)
    current_user.likes.where(likeable_type: type, likeable_id: id).first
end

def notify_friends(friends, issuer, post)
    friends.each do | friend |
        friend.notifications.create(notifiable: post, issuer: issuer)
    end
end

def notify_followers(followers, issuer, post)
    followers.each do | follower |
        follower.notifications.create(notifiable: post, issuer: issuer)
    end
end

def send_notifications(friends, followers, issuer, post)
    notify_friends(friends, issuer, post)
    notify_followers(followers, issuer, post)
end

# dummy users generalities
first_names = ["Steven", "Mack", "Joanna", "Lot", "Frederick", "Sieglinde", "Oliver", "Winston", "Charles", "Victoria"]
last_names = ["Locking", "Cortas", "Vilnius", "Bet-Beniamin", "Collins", "West", "Crom", "Jill", "David", "Marsh"]
emails = ["user1@proton.com", "user2@proton.com", "user3@proton.com", "user4@proton.com", "user5@proton.com", "user6@proton.com", "user7@proton.com", "user8@proton.com", "user9@proton.com", "user10@proton.com"]
bios = ["I abandoned civilization. Forever.", "", "", "Don't stick your nose where it doesn't belong", "", "Hello there, pipsqueak!", "", "", "Mind your manners!", ""]
users = Array.new
i = 0
emails.each do | mail |
    user = User.create!(first_name: first_names[i], last_name: last_names[i], email: mail, password: "123456")
    user.profile.bio = bio[i]
    users << user
    i += 1
end

# user 1 sends friend requests to 2, 3, 6, 7, 8, 10
r = users[0].sent_requests.create(receiver: users[1])
users[1].notifications.create(notifiable: r, issuer: users[0])
r = users[0].sent_requests.create(receiver: users[2])
users[2].notifications.create(notifiable: r, issuer: users[0])
r = users[0].sent_requests.create(receiver: users[5])
users[5].notifications.create(notifiable: r, issuer: users[0])
r = users[0].sent_requests.create(receiver: users[6])
users[6].notifications.create(notifiable: r, issuer: users[0])
r = users[0].sent_requests.create(receiver: users[7])
users[7].notifications.create(notifiable: r, issuer: users[0])
r = users[0].sent_requests.create(receiver: users[9])
users[9].notifications.create(notifiable: r, issuer: users[0])

# user 2 sends friend requests to 3, 4, 5 and 9
r = users[1].sent_requests.create(receiver: users[2])
users[2].notifications.create(notifiable: r, issuer: users[1])
r = users[1].sent_requests.create(receiver: users[3])
users[3].notifications.create(notifiable: r, issuer: users[1])
r = users[1].sent_requests.create(receiver: users[4])
users[4].notifications.create(notifiable: r, issuer: users[1])
r = users[1].sent_requests.create(receiver: users[8])
users[8].notifications.create(notifiable: r, issuer: users[1])

# user 3 sends friend requests to 2, 4, and 9
r = users[2].sent_requests.create(receiver: users[1])
users[1].notifications.create(notifiable: r, issuer: users[2])
r = users[2].sent_requests.create(receiver: users[3])
users[3].notifications.create(notifiable: r, issuer: users[2])
r = users[2].sent_requests.create(receiver: users[8])
users[8].notifications.create(notifiable: r, issuer: users[2])

# user 4 sends friend requests to 1, 5, 7 and 8
r = users[3].sent_requests.create(receiver: users[0])
users[0].notifications.create(notifiable: r, issuer: users[3])
r = users[3].sent_requests.create(receiver: users[4])
users[4].notifications.create(notifiable: r, issuer: users[3])
r = users[3].sent_requests.create(receiver: users[6])
users[6].notifications.create(notifiable: r, issuer: users[3])
r = users[3].sent_requests.create(receiver: users[7])
users[7].notifications.create(notifiable: r, issuer: users[3])

# user 5 sends friend requests to 1, 6 and 10
r = users[4].sent_requests.create(receiver: users[0])
users[0].notifications.create(notifiable: r, issuer: users[4])
r = users[4].sent_requests.create(receiver: users[6])
users[6].notifications.create(notifiable: r, issuer: users[4])
r = users[4].sent_requests.create(receiver: users[9])
users[9].notifications.create(notifiable: r, issuer: users[4])

# user 6 sends friends requests to 2, 4 and 8
r = users[5].sent_requests.create(receiver: users[1])
users[1].notifications.create(notifiable: r, issuer: users[5])
r = users[5].sent_requests.create(receiver: users[3])
users[3].notifications.create(notifiable: r, issuer: users[5])
r = users[5].sent_requests.create(receiver: users[7])
users[7].notifications.create(notifiable: r, issuer: users[5])

# user 7 sends friend requests to 3, 5, 8 and 9
r = users[6].sent_requests.create(receiver: users[2])
users[2].notifications.create(notifiable: r, issuer: users[6])
r = users[6].sent_requests.create(receiver: users[4])
users[4].notifications.create(notifiable: r, issuer: users[6])
r = users[6].sent_requests.create(receiver: users[7])
users[7].notifications.create(notifiable: r, issuer: users[6])
r = users[6].sent_requests.create(receiver: users[8])
users[8].notifications.create(notifiable: r, issuer: users[6])

# user 8 sends friend requests to 2, 5 and 9
r = users[7].sent_requests.create(receiver: users[1])
users[1].notifications.create(notifiable: r, issuer: users[7])
r = users[7].sent_requests.create(receiver: users[4])
users[4].notifications.create(notifiable: r, issuer: users[7])
r = users[7].sent_requests.create(receiver: users[8])
users[8].notifications.create(notifiable: r, issuer: users[7])

# user 9 sends friend requests to 1, 4, 5 and 6
r = users[8].sent_requests.create(receiver: users[0])
users[0].notifications.create(notifiable: r, issuer: users[8])
r = users[8].sent_requests.create(receiver: users[3])
users[3].notifications.create(notifiable: r, issuer: users[8])
r = users[8].sent_requests.create(receiver: users[4])
users[4].notifications.create(notifiable: r, issuer: users[8])
r = users[8].sent_requests.create(receiver: users[5])
users[5].notifications.create(notifiable: r, issuer: users[8])

# user 10 sends friend requests to 2, 4 and 7
r = users[9].sent_requests.create(receiver: users[1])
users[1].notifications.create(notifiable: r, issuer: users[9])
r = users[9].sent_requests.create(receiver: users[3])
users[3].notifications.create(notifiable: r, issuer: users[9])
r = users[9].sent_requests.create(receiver: users[6])
users[6].notifications.create(notifiable: r, issuer: users[9])

# user 1 received requests from 4, 5 and 9
# accepts 5
friendship = users[0].initiated_friendships.create(friend_two: users[4])
find_request(users[4], users[0]).destroy
users[4].notifications.create(notifiable: friendship, issuer: users[0])
# accepts 9
friendship = users[0].initiated_friendships.create(friend_two: users[8])
find_request(users[8], users[0]).destroy
users[8].notifications.create(notifiable: friendship, issuer: users[0])

# user 2 received requests from 1, 3, 6, 8 and 10
# accepts 1
friendship = users[1].initiated_friendships.create(friend_two: users[0])
find_request(users[0], users[1]).destroy
users[0].notifications.create(notifiable: friendship, issuer: users[1])
# accepts 6
friendship = users[1].initiated_friendships.create(friend_two: users[5])
find_request(users[5], users[1]).destroy
users[5].notifications.create(notifiable: friendship, issuer: users[1])
# accepts 10
friendship = users[1].initiated_friendships.create(friend_two: users[9])
find_request(users[9], users[1]).destroy
users[9].notifications.create(notifiable: friendship, issuer: users[1])

# user 3 received requests from 1, 2 and 7
# accepts 2
friendship = users[2].initiated_friendships.create(friend_two: users[1])
find_request(users[1], users[2]).destroy
users[1].notifications.create(notifiable: friendship, issuer: users[2])
# accepts 7
friendship = users[2].initiated_friendships.create(friend_two: users[6])
find_request(users[6], users[2]).destroy
users[6].notifications.create(notifiable: friendship, issuer: users[2])

# user 4 received requests from 2, 3, 6, 9 and 10
# accepts 2
friendship = users[3].initiated_friendships.create(friend_two: users[1])
find_request(users[1], users[3]).destroy
users[1].notifications.create(notifiable: friendship, issuer: users[3])
# accepts 6
friendship = users[3].initiated_friendships.create(friend_two: users[5])
find_request(users[5], users[3]).destroy
users[5].notifications.create(notifiable: friendship, issuer: users[3])
# accepts 9
friendship = users[3].initiated_friendships.create(friend_two: users[8])
find_request(users[8], users[3]).destroy
users[8].notifications.create(notifiable: friendship, issuer: users[3])
# accepts 10
friendship = users[3].initiated_friendships.create(friend_two: users[9])
find_request(users[9], users[3]).destroy
users[9].notifications.create(notifiable: friendship, issuer: users[3])

# user 5 received requests from 2, 4, 7, 8 and 9
# accepts 8
friendship = users[4].initiated_friendships.create(friend_two: users[7])
find_request(users[7], users[4]).destroy
users[7].notifications.create(notifiable: friendship, issuer: users[4])
# accepts 9
friendship = users[4].initiated_friendships.create(friend_two: users[8])
find_request(users[8], users[4]).destroy
users[8].notifications.create(notifiable: friendship, issuer: users[4])

# user 6 received requests from 1 and 9
# accepts 1
friendship = users[5].initiated_friendships.create(friend_two: users[0])
find_request(users[0], users[5]).destroy
users[0].notifications.create(notifiable: friendship, issuer: users[5])
# accepts 9
friendship = users[5].initiated_friendships.create(friend_two: users[8])
find_request(users[8], users[5]).destroy
users[8].notifications.create(notifiable: friendship, issuer: users[5])

# user 7 received requests from 1, 4, 5 and 10
# accepts 1
friendship = users[6].initiated_friendships.create(friend_two: users[0])
find_request(users[0], users[6]).destroy
users[0].notifications.create(notifiable: friendship, issuer: users[6])
# accepts 10
friendship = users[6].initiated_friendships.create(friend_two: users[9])
find_request(users[9], users[6]).destroy
users[9].notifications.create(notifiable: friendship, issuer: users[6])

# user 8 received requests from 1, 4, 6 and 7
# accepts 6
friendship = users[7].initiated_friendships.create(friend_two: users[5])
find_request(users[5], users[7]).destroy
users[5].notifications.create(notifiable: friendship, issuer: users[7])
# accepts 7
friendship = users[7].initiated_friendships.create(friend_two: users[6])
find_request(users[6], users[7]).destroy
users[6].notifications.create(notifiable: friendship, issuer: users[7])

# user 9 received requests from 2, 3, 7 and 8
# accepts 2
friendship = users[8].initiated_friendships.create(friend_two: users[1])
find_request(users[1], users[8]).destroy
users[1].notifications.create(notifiable: friendship, issuer: users[8])
# accepts 3
friendship = users[8].initiated_friendships.create(friend_two: users[2])
find_request(users[2], users[8]).destroy
users[2].notifications.create(notifiable: friendship, issuer: users[8])
# accepts 8
friendship = users[8].initiated_friendships.create(friend_two: users[7])
find_request(users[7], users[8]).destroy
users[7].notifications.create(notifiable: friendship, issuer: users[8])

# user 10 received requests from 1, and 5
# accepts 1
friendship = users[9].initiated_friendships.create(friend_two: users[0])
find_request(users[0], users[9]).destroy
users[0].notifications.create(notifiable: friendship, issuer: users[9])
# accepts 5
friendship = users[9].initiated_friendships.create(friend_two: users[4])
find_request(users[4], users[9]).destroy
users[4].notifications.create(notifiable: friendship, issuer: users[9])

# user 1 follows 3 and 8
f = users[0].followed_people.create(follow: users[2])
users[2].notifications.create(notifiable: f, issuer: users[0])
f = users[0].followed_people.create(follow: users[7])
users[7].notifications.create(notifiable: f, issuer: users[0])

# user 2 follows 7 and 8
f = users[1].followed_people.create(follow: users[6])
users[6].notifications.create(notifiable: f, issuer: users[1])
f = users[1].followed_people.create(follow: users[7])
users[7].notifications.create(notifiable: f, issuer: users[1])

# user 3 follows 1, 4 and 10
f = users[2].followed_people.create(follow: users[0])
users[0].notifications.create(notifiable: f, issuer: users[2])
f = users[2].followed_people.create(follow: users[3])
users[3].notifications.create(notifiable: f, issuer: users[2])
f = users[2].followed_people.create(follow: users[9])
users[9].notifications.create(notifiable: f, issuer: users[2])

# user 4 follows 1
f = users[3].followed_people.create(follow: users[0])
users[0].notifications.create(notifiable: f, issuer: users[3])

# user 5 follows 3 and 4
f = users[4].followed_people.create(follow: users[2])
users[2].notifications.create(notifiable: f, issuer: users[4])
f = users[4].followed_people.create(follow: users[3])
users[3].notifications.create(notifiable: f, issuer: users[4])

# user 6 follows 3 and 5
f = users[5].followed_people.create(follow: users[2])
users[2].notifications.create(notifiable: f, issuer: users[5])
f = users[5].followed_people.create(follow: users[4])
users[4].notifications.create(notifiable: f, issuer: users[5])

# user 7 follows 2
f = users[6].followed_people.create(follow: users[1])
users[1].notifications.create(notifiable: f, issuer: users[6])

# user 8 follows 1 and 8
f = users[7].followed_people.create(follow: users[0])
users[0].notifications.create(notifiable: f, issuer: users[7])
f = users[7].followed_people.create(follow: users[8])
users[8].notifications.create(notifiable: f, issuer: users[7])

# user 9 follows no one

# user 10 follows 8
f = users[9].followed_people.create(follow: users[7])
users[7].notifications.create(notifiable: f, issuer: users[9])

# user 1 posts
post_1 = users[0].posts.create postable: TextPost.new(title: "Best decision ever", body: "I must admit that returning to monke seemed like a very radical decision, but it has been amazing. I would definitely recommend this to all of my friends, if I could still contact them. But MonkeBook is great!"), author: users[0]
send_notifications(users[0].friends, users[0].followers, users[0], post_1)

i_post = ImagePost.new(title: "Drop them")
file = URI.open("https://res.cloudinary.com/dkanag99x/image/upload/v1655048479/projects/facebook/chad.jpg")
i_post.image.attach(io: file, filename: "chad.jpg") 
post_2 = users[0].posts.create postable: i_post, author: users[0]
send_notifications(users[0].friends, users[0].followers, users[0], post_2)

post_3 = users[0].posts.create postable: TextPost.new(title: "Have you ever tried strawberries?", body: "Somehow they leave a strange taste in my mouth after eating them."), author: users[0]
send_notifications(users[0].friends, users[0].followers, users[0], post_3)

# user 5 posts
i_post = ImagePost.new(title: "Money money money")
file = URI.open("https://res.cloudinary.com/dkanag99x/image/upload/v1655048479/projects/facebook/ancap.jpg")
i_post.image.attach(io: file, filename: "ancap.jpg")
post_4 = users[4].posts.create postable: i_post, author: users[4]
send_notifications(users[4].friends, users[4].followers, users[4], post_4)
[users[1], users[2], users[5], users[7], users[8]].each do | user |
    like = user.likes.create(likeable: post_4)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

post_5 = users[4].posts.create postable: TextPost.new(title: "WTT makeshift couch", body: "I have a couch. Tell me what you would give me for it."), author: users[4]
send_notifications(users[4].friends, users[4].followers, users[4], post_5)
post_6 = users[4].posts.create postable: TextPost.new(title: "I saw a honeycomb today", body: "How do you guys handle the stings? I can't come up with a good way to avoid them."), author: users[4]
send_notifications(users[4].friends, users[4].followers, users[4], post_6)

# user 7 posts
post_7 = users[6].posts.create postable: TextPost.new(title: "Watching the sunset is so soothing", body: "I love the colors as they lazily pierce the greenery."), author: users[6]
send_notifications(users[6].friends, users[6].followers, users[6], post_7)
[users[3], users[4], users[7], users[8]].each do | user |
    like = user.likes.create(likeable: post_7)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

i_post = ImagePost.new(title: "Silly human")
file = URI.open("https://res.cloudinary.com/dkanag99x/image/upload/v1655048479/projects/facebook/money.jpg")
i_post.image.attach(io: file, filename: "money.jpg") 
post_8 = users[6].posts.create postable: i_post, author: users[6]
send_notifications(users[6].friends, users[6].followers, users[6], post_8)

post_9 = users[6].posts.create postable: TextPost.new(title: "When the tiger prowls", body: "I slather coconut oil all over my dome and scare it away with the bright light reflecting upon it."), author: users[6]
send_notifications(users[6].friends, users[6].followers, users[6], post_9)

# user 10 posts
post_10 = users[9].posts.create postable: TextPost.new(title: "Piglets", body: "They're free food! Just pick 'em up and eat 'em when you come across them. Easy preys."), author: users[9]
send_notifications(users[9].friends, users[9].followers, users[9], post_10)
[users[3], users[7]].each do | user |
    like = user.likes.create(likeable: post_10)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

post_11 = users[9].posts.create postable: TextPost.new(title: "Heckin' hogs", body: "Reminder to look around for signs of mom hog when stalking piglets. They are damn dangerous."), author: users[9]
send_notifications(users[9].friends, users[9].followers, users[9], post_11)
[users[3], users[7]].each do | user |
    like = user.likes.create(likeable: post_11)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

# comments on post_1, from user 1
comment_1 = users[4].comments.create(commentable: post_1 , root: post_1, body: "Welcome to the tribe, famalam!")
comment_1.commentable.author.notifications.create(notifiable: comment_1, issuer: users[4])
like_1 = users[0].likes.create(likeable: comment_1)
like_1.likeable.author.notifications.create(notifiable: like_1, issuer: users[0])

comment_2 = users[3].comments.create(commentable: post_1 , root: post_1, body: "OOGA BOOGA")
comment_2.commentable.author.notifications.create(notifiable: comment_2, issuer: users[3])
[users[2], users[7]].each do | user |
    like = user.likes.create(likeable: comment_2)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

comment_3 = users[7].comments.create(commentable: comment_2 , root: post_1, body: "UNGA BUNGA")
comment_3.commentable.author.notifications.create(notifiable: comment_3, issuer: users[7])
[users[2], users[5]].each do | user |
    like = user.likes.create(likeable: comment_2)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

comment_4 = users[8].comments.create(commentable: comment_3 , root: post_1, body: "You guys always make a scene...")
comment_4.commentable.author.notifications.create(notifiable: comment_4, issuer: users[8])

comment_5 = users[3].comments.create(commentable: comment_4 , root: post_1, body: "Party pooper")
comment_5.commentable.author.notifications.create(notifiable: comment_5, issuer: users[3])

comment_6 = users[8].comments.create(commentable: comment_5 , root: post_1, body: "Well excuuuuuuuse me for having standards")
comment_6.commentable.author.notifications.create(notifiable: comment_6, issuer: users[8])

comment_7 = users[7].comments.create(commentable: comment_6 , root: post_1, body: "Dude lighten up we're LARPing as apes")
comment_7.commentable.author.notifications.create(notifiable: comment_7, issuer: users[7])
[users[2], users[5]].each do | user |
    like = user.likes.create(likeable: comment_2)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

comment_8 = users[0].comments.create(commentable: comment_1 , root: post_1, body: "Aww shucks, thanks fren!")
comment_8.commentable.author.notifications.create(notifiable: comment_8, issuer: users[0])
[users[4]].each do | user |
    like = user.likes.create(likeable: comment_2)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

comment_9 = users[1].comments.create(commentable: comment_1 , root: post_1, body: "Brown nose...")
comment_9.commentable.author.notifications.create(notifiable: comment_9, issuer: users[1])

comment_10 = users[8].comments.create(commentable: comment_7 , root: post_1, body: "I wonder why I haven't blocked you guys yet")
comment_10.commentable.author.notifications.create(notifiable: comment_10, issuer: users[8])

comment_11 = users[3].comments.create(commentable: comment_10 , root: post_1, body: "<3")
comment_11.commentable.author.notifications.create(notifiable: comment_11, issuer: users[3])

comment_12 = users[8].comments.create(commentable: comment_11 , root: post_1, body: "...")
comment_12.commentable.author.notifications.create(notifiable: comment_12, issuer: users[8])

# comments on post 2, from user 1
comment_1 = users[6].comments.create(commentable: post_2 , root: post_2, body: "So now it has come to this, huh? Dang piggy gang got a new underling. Of course")
comment_1.commentable.author.notifications.create(notifiable: comment_1, issuer: users[6])

comment_2 = users[0].comments.create(commentable: comment_1 , root: post_2, body: "Dude, what are you on about?")
comment_2.commentable.author.notifications.create(notifiable: comment_2, issuer: users[0])

comment_3 = users[6].comments.create(commentable: comment_2 , root: post_2, body: "And now it feigns ignorance, how original")
comment_3.commentable.author.notifications.create(notifiable: comment_3, issuer: users[6])

comment_4 = users[0].comments.create(commentable: comment_3 , root: post_2, body: "Listen, I just got here and I wanted to talk with someone. What did I do wrong?")
comment_4.commentable.author.notifications.create(notifiable: comment_4, issuer: users[0])

comment_5 = users[6].comments.create(commentable: comment_4 , root: post_2, body: "The fact you're asking prove your arrogance and ill-manners.")
comment_5.commentable.author.notifications.create(notifiable: comment_5, issuer: users[6])

comment_6 = users[0].comments.create(commentable: comment_5 , root: post_2, body: "I'm gonna block you if you keep this up...")
comment_6.commentable.author.notifications.create(notifiable: comment_6, issuer: users[0])

comment_7 = users[6].comments.create(commentable: comment_6 , root: post_2, body: "Go ahead, see if I care")
comment_7.commentable.author.notifications.create(notifiable: comment_7, issuer: users[6])

comment_8 = users[8].comments.create(commentable: comment_5 , root: post_2, body: "Don't mind him, he's just having a bad day.")
comment_8.commentable.author.notifications.create(notifiable: comment_7, issuer: users[8])

comment_9 = users[0].comments.create(commentable: comment_8 , root: post_2, body: "I hope so...")
comment_9.commentable.author.notifications.create(notifiable: comment_9, issuer: users[0])

comment_5 = users[6].comments.create(commentable: comment_8 , root: post_2, body: "I DON'T NEED A WHITE KNIGHT")
comment_5.commentable.author.notifications.create(notifiable: comment_5, issuer: users[6])

block = users[0].blocked_people.create(blocked: users[6])
find_friendship(users[6], users[0]).destroy if friends?(users[6], users[0])
find_request(users[6], users[0]).destroy if !find_request(users[6], users[0]).nil?
clear_follow_relations(users[6], users[0])
users[6].notifications.create(notifiable: block, issuer: users[0])

# comments on post 9, from user 7
comment_1 = users[9].comments.create(commentable: post_11 , root: post_11, body: "Please do not engage the wildlife")
comment_1.commentable.author.notifications.create(notifiable: comment_1, issuer: users[9])

comment_2 = users[6].comments.create(commentable: comment_1 , root: post_11, body: "I will engage. Culinarily.")
comment_2.commentable.author.notifications.create(notifiable: comment_2, issuer: users[6])

comment_3 = users[3].comments.create(commentable: comment_2 , root: post_11, body: "Way to go man")
comment_3.commentable.author.notifications.create(notifiable: comment_3, issuer: users[3])

comment_4 = users[0].comments.create(commentable: post_11 , root: post_11, body: "Any tips on cooking them?")
comment_4.commentable.author.notifications.create(notifiable: comment_3, issuer: users[0])

comment_5 = users[9].comments.create(commentable: comment_4 , root: post_11, body: "Ya gotta bleed 'em first, then you slather the bug paste on. After that, put it on the spitorast until desired")
comment_5.commentable.author.notifications.create(notifiable: comment_5, issuer: users[6])
[users[0], users[3], users[7]].each do | user |
    like = user.likes.create(likeable: comment_2)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

comment_6 = users[0].comments.create(commentable: comment_5 , root: post_11, body: "Thanks man, I'll keep that in mind")
comment_6.commentable.author.notifications.create(notifiable: comment_6, issuer: users[0])

#comments on post 5, from user 5
comment_1 = users[1].comments.create(commentable: post_5 , root: post_5, body: "Offering two ornamental fans")
comment_1.commentable.author.notifications.create(notifiable: comment_1, issuer: users[1])

comment_2 = users[7].comments.create(commentable: comment_1 , root: post_5, body: "I raise you a stuffed macaque")
comment_2.commentable.author.notifications.create(notifiable: comment_2, issuer: users[7])
[users[2], users[4], users[9]].each do | user |
    like = user.likes.create(likeable: comment_2)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

comment_3 = users[4].comments.create(commentable: comment_2 , root: post_5, body: "Make it two and we got a deal")
comment_3.commentable.author.notifications.create(notifiable: comment_3, issuer: users[3])

comment_4 = users[6].comments.create(commentable: post_5 , root: post_5, body: "A piglet")
comment_4.commentable.author.notifications.create(notifiable: comment_4, issuer: users[6])
[users[0], users[3]].each do | user |
    like = user.likes.create(likeable: comment_4)
    like.likeable.author.notifications.create(notifiable: like, issuer: user)
end

comment_5 = users[2].comments.create(commentable: post_5 , root: post_5, body: "Meet me behind the big tree")
comment_5.commentable.author.notifications.create(notifiable: comment_5, issuer: users[2])

comment_6 = users[8].comments.create(commentable: post_5 , root: post_5, body: "Can you be more specific? What is it made of?")
comment_6.commentable.author.notifications.create(notifiable: comment_6, issuer: users[8])