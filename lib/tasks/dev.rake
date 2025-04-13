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

    # Create chat start times with varied timeline including years ago
    if chat.subject == "Book Club" || chat.subject == "Career Advice"
      # These chats started 1-3 years ago
      chat_start_time = rand(1..3).years.ago
    elsif chat.subject == "Tech Discussion" || chat.subject == "Study Group"
      # These chats started 6-18 months ago
      chat_start_time = rand(6..18).months.ago
    else
      # Other chats started 1-30 days ago
      chat_start_time = rand(1..30).days.ago
    end
    
    root_message = Message.create!(
      chat: chat,
      author: first_author,
      content: "Let's start discussing #{chat.subject}!",
      created_at: chat_start_time,
      updated_at: chat_start_time
    )

    # Determine message count based on chat age
    if chat_start_time < 1.year.ago
      message_count = rand(70..120) # More messages for very old chats
    elsif chat_start_time < 6.months.ago
      message_count = rand(50..80) # Many messages for older chats
    else
      message_count = rand(20..40) # Fewer messages for recent chats
    end
    
    current_time = chat_start_time
    chat_duration = Time.current - chat_start_time
    
    # For older chats, distribute messages with periods of activity and inactivity
    message_count.times do |i|
      author = chat_users.sample
      
      # Create varied message timings with realistic patterns
      if chat_start_time < 6.months.ago
        if i % 15 == 0 && i > 0
          # Add a bigger gap every ~15 messages to simulate periods of inactivity
          time_increment = rand(5..30).days
        elsif rand < 0.8
          # 80% of messages come in bursts (5-60 minutes apart)
          time_increment = rand(5..60).minutes
        else
          # 20% of messages have longer gaps (1-12 hours)
          time_increment = rand(1..12).hours
        end
      else
        # For newer chats, messages are more evenly spaced
        time_increment = rand(1.minute..6.hours)
      end
      
      current_time += time_increment
      
      # Don't create messages in the future
      break if current_time > Time.current
      
      # For very old chats, ensure some recent activity too
      if chat_start_time < 1.year.ago && i > message_count * 0.7 && current_time < 1.month.ago
        # Jump ahead to create some recent messages
        current_time = rand(1..30).days.ago
      end

      if rand < 0.7
        # Choose message content based on chat type and age (70% of messages)
        if chat.subject == "Book Club" && chat_start_time < 1.year.ago && current_time < 6.months.ago
          # Book club specific older messages
          content = [
            "I just started reading the first chapter!",
            "What does everyone think about the protagonist?",
            "The author's style reminds me of Hemingway.",
            "Should we meet next Thursday to discuss chapters 1-3?",
            "I found this book challenging at first but it's growing on me.",
            "Has anyone read the author's previous works?",
            "I think the themes in chapters 4-5 are particularly relevant today.",
            "I finished the book last night - amazing ending!",
            "What should we read next month?",
            "I've made a list of discussion questions for our meeting.",
            "I think the character development was superb in this one.",
            "This was definitely better than last month's selection.",
            "Are we still meeting at the coffee shop on Main St?",
            "Did anyone see the movie adaptation?",
            "Who's bringing snacks to the next discussion?",
            "I found a podcast where they interview the author."
          ].sample
        elsif chat.subject == "Tech Discussion" && chat_start_time < 1.year.ago
          # Tech discussion specific messages - show evolution of tech topics
          content = [
            "Anyone tried the new JavaScript framework yet?",
            "I'm still on Rails 5, is it worth upgrading?",
            "Cloud functions or containers - thoughts?",
            "I'm setting up my development environment on the new M1 Mac.",
            "This new AI tool is impressive for code completion.",
            "Who's going to the developer conference next month?",
            "My company just migrated everything to Kubernetes.",
            "Virtual reality might be the next big platform for developers.",
            "Web3 - hype or the future?",
            "I just switched to VS Code and it's been a game changer.",
            "TypeScript has completely changed how I build JavaScript apps.",
            "Remember when everyone was excited about Mongo? Now it's all about PostgreSQL again.",
            "I miss the simplicity of development before microservices.",
            "Anyone using GitHub Copilot? Worth the price?",
            "I think we're seeing a return to server-rendered frameworks."
          ].sample
        elsif current_time < 3.months.ago
          # Generic older messages
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
          # More recent messages
          content = [
            "Sorry I've been quiet, been really busy lately.",
            "Let's revive this discussion!",
            "Any updates on this topic?",
            "I'm back and interested in continuing our conversation.",
            "Has anything changed since we last discussed this?",
            "I just saw something related to our previous discussion.",
            "New year, new ideas on this topic?",
            "I'm still working on this, just wanted to give an update.",
            "Anyone still active in this chat?",
            "Is this group still meeting?",
            "I'd like to revisit our last discussion point.",
            "Let's schedule a new time to reconnect on this.",
            "I have some new insights to share with everyone.",
            "Sorry for going MIA, I'm back now!",
            "Does anyone want to restart our regular discussions?"
          ].sample
        end
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
    
    # Update chat timestamps to match their most recent message
    latest_message = chat.messages.order(created_at: :desc).first
    if latest_message.present?
      chat.update_columns(updated_at: latest_message.created_at)
    end
  end

  puts "Sample data has been created!"
end
