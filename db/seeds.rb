# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# useful methods

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

default_avatars = Array.new
default_avatars << "https://res.cloudinary.com/dkanag99x/image/upload/v1655047622/projects/facebook/default_avatar_1.png"
default_avatars << "https://res.cloudinary.com/dkanag99x/image/upload/v1655231435/projects/facebook/default_avatar_2.jpg"
default_avatars << "https://res.cloudinary.com/dkanag99x/image/upload/v1655231440/projects/facebook/default_avatar_3.jpg"
# i_post.image.attach(io: file, filename: "chad.jpg") 

users = Array.new
# create users
i = 0
emails.each do | mail |
    user = User.create(first_name: first_names[i], last_name: last_names[i], email: mail, password: "123456")
    avatar = default_avatars.sample
    user.profile.avatar.attach(io: URI.open(avatar), filename: avatar.sub(/.*?facebook/, '')[1..-1])
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

# 1 - 5, 9, 2, 6, 7, 10
# 2 - 1, 6, 10, 3, 4, 9                                                                                           
# 3 - 2, 7, 9                                                                                                     
# 4 - 2, 6, 9, 10                                                                                                 
# 5 - 8, 9, 1, 10                                                                                                 
# 6 - 1, 9, 2, 4, 8                                                                                               
# 7 - 1, 10, 3, 8                                                                                                 
# 8 - 6, 7, 5, 9                                                                                                  
# 9 - 2, 3, 8, 1, 4, 5, 6                                                                                         
# 10 - 1, 5, 2, 4, 7  

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
post = users[0].posts.create postable: TextPost.new(title: "Best decision ever", body: "I must admit that returning to monke seemed like a very radical decision, but it has been amazing. I would definitely recommend this to all of my friends, if I could still contact them. But MonkeBook is great!"), author: users[0]
send_notifications(users[0].friends, users[0].followers, users[0], post)

i_post = ImagePost.new(title: "Drop them")
file = URI.open("https://res.cloudinary.com/dkanag99x/image/upload/v1655048479/projects/facebook/chad.jpg")
i_post.image.attach(io: file, filename: "chad.jpg") 
post = users[0].posts.create postable: i_post, author: users[0]
send_notifications(users[0].friends, users[0].followers, users[0], post)

post = users[0].posts.create postable: TextPost.new(title: "Have you ever tried strawberries?", body: "Somehow they leave a strange taste in my mouth after eating them."), author: users[0]
send_notifications(users[0].friends, users[0].followers, users[0], post)

# user 5 posts
i_post = ImagePost.new(title: "Money money money")
file = URI.open("https://res.cloudinary.com/dkanag99x/image/upload/v1655048479/projects/facebook/ancap.jpg")
i_post.image.attach(io: file, filename: "ancap.jpg")
post = users[4].posts.create postable: i_post, author: users[4]
send_notifications(users[4].friends, users[4].followers, users[4], post)

post = users[4].posts.create postable: TextPost.new(title: "WTT makeshift couch", body: "I have a couch. Tell me what you would give me for it."), author: users[4]
send_notifications(users[4].friends, users[4].followers, users[4], post)
post = users[4].posts.create postable: TextPost.new(title: "I saw a honeycomb today", body: "How do you guys handle the stings? I can't come up with a good way to avoid them."), author: users[4]
send_notifications(users[4].friends, users[4].followers, users[4], post)

# user 7 posts
post = users[6].posts.create postable: TextPost.new(title: "Watching the sunset is so soothing", body: "I love the colors as they lazily pierce the greenery."), author: users[6]
send_notifications(users[6].friends, users[6].followers, users[6], post)

i_post = ImagePost.new(title: "Silly human")
file = URI.open("https://res.cloudinary.com/dkanag99x/image/upload/v1655048479/projects/facebook/money.jpg")
i_post.image.attach(io: file, filename: "money.jpg") 
post = users[6].posts.create postable: i_post, author: users[6]
send_notifications(users[6].friends, users[6].followers, users[6], post)

post = users[6].posts.create postable: TextPost.new(title: "Watching the sunset is so soothing", body: "I love the colors as they lazily pierce the greenery."), author: users[6]
send_notifications(users[6].friends, users[6].followers, users[6], post)

# user 10 posts
post = users[9].posts.create postable: TextPost.new(title: "Piglets", body: "They're free food! Just pick 'em up and eat 'em when you come across them. Easy preys."), author: users[9]
send_notifications(users[9].friends, users[9].followers, users[9], post)

post = users[9].posts.create postable: TextPost.new(title: "Heckin' hogs", body: "Reminder to look around for signs of mom hog when stalking piglets. They are damn dangerous."), author: users[9]
send_notifications(users[9].friends, users[9].followers, users[9], post)