desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do
  puts "Creating sample users..."

  # Reset the database
  if Rails.env.development?
    User.destroy_all
    Chat.destroy_all
    ChatUser.destroy_all
    Message.destroy_all
  end

  # Create 25 users
  users = []
  25.times do |i|
    name = Faker::Internet.unique.username(specifier: 5..8)
    users << User.create!(name: name)
  end

  puts "Creating sample chats..."
  # Create chats
  chats = []
  chat_subjects = [
    "Project Planning",
    "Weekend Plans",
    "Tech Discussion",
    "Book Club",
    "Team Meeting",
    "Gaming Group",
    "Travel Plans",
    "Fitness Challenge",
    "Movie Recommendations",
    "Cooking Club",
    "Home Improvement",
    "Career Advice",
    "Study Group"
  ]

  chat_subjects.each_with_index do |subject, i|
    creator = users[i % users.length]
    chat = Chat.create!(
      creator: creator,
      subject: subject
    )
    chats << chat

    # Add creator and random participants to the chat
    chat.chat_users.create!(user: creator)

    # Add 5-10 random participants
    participant_count = rand(5..10)
    other_users = users.reject { |u| u == creator }.sample(participant_count)

    other_users.each do |user|
      chat.chat_users.create!(user: user)
    end
  end

  puts "Creating sample messages..."
  # Create messages for each chat
  chats.each do |chat|
    # Create a root message for each chat
    chat_users = chat.users
    first_author = chat_users.sample

    # Create a chat start time between 1-30 days ago
    chat_start_time = rand(1..30).days.ago
    
    root_message = Message.create!(
      chat: chat,
      author: first_author,
      content: "Let's start discussing #{chat.subject}!",
      created_at: chat_start_time,
      updated_at: chat_start_time
    )

    # Create 30-50 replies
    message_count = rand(30..50)
    
    # Calculate average time between messages (5 minutes to 3 hours)
    total_chat_duration = Time.current - chat_start_time
    avg_time_between_messages = total_chat_duration / message_count

    current_time = chat_start_time

    message_count.times do |i|
      author = chat_users.sample
      
      # Add a random time increment (between 1 minute and 6 hours)
      time_increment = rand(1.minute..6.hours)
      current_time += time_increment
      
      # Don't create messages in the future
      break if current_time > Time.current

      if rand < 0.7
        # Use pre-defined messages 70% of the time
        content = [
          "I think we should consider option A.",
          "Has anyone looked into the alternatives?",
          "When is our next meeting?",
          "I'm available tomorrow afternoon.",
          "Let's try to wrap this up by Friday.",
          "What do you all think about this approach?",
          "I agree with the previous point.",
          "I'm not sure that would work well.",
          "Can we schedule some time to discuss this more?",
          "This looks promising!",
          "Let me know if you need any help with this.",
          "I've been researching this topic extensively.",
          "Let's set up a follow-up meeting to discuss.",
          "I've attached some resources for reference.",
          "Does anyone have experience with this?",
          "Can someone summarize what we've decided so far?",
          "I think we should revisit our original goals.",
          "This is a great discussion, everyone!",
          "Has anyone considered the impact on our timeline?",
          "I'm excited about where this is heading.",
          "Let's make sure we document this properly.",
          "I'd like to volunteer for this task.",
          "Let's involve the other team members as well.",
          "This reminds me of our previous project.",
          "We should set some clear milestones."
        ].sample
      else
        # Generate longer, paragraph-style messages 30% of the time
        sentences = rand(3..6)
        content = Faker::Lorem.paragraph(sentence_count: sentences)
      end

      message = Message.create!(
        chat: chat,
        author: author,
        content: content,
        created_at: current_time,
        updated_at: current_time
      )
    end
  end

  puts "Sample data has been created!"
end
