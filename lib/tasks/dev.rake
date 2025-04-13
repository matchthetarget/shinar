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
    "Berlin Restaurant Recommendations",
    "Tokyo Subway Directions",
    "CDMX Street Food Guide",
    "Paris Museum Hours",
    "Seoul Shopping District",
    "NYC Theater Tickets",
    "Berlin Nightlife",
    "Tokyo Cherry Blossom Spots",
    "CDMX Taxi Fare",
    "Paris Cafe Conversation",
    "Seoul Market Bargaining",
    "NYC Subway Directions",
    "Berlin Hotel Services"
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

    # Root message content based on chat subject
    root_content = case chat.subject
    when "Berlin Restaurant Recommendations"
        "Excuse me, could you recommend a good restaurant nearby?"
    when "Tokyo Subway Directions"
        "Sumimasen, how do I get to Shibuya station from here?"
    when "CDMX Street Food Guide"
        "Hola! Where can I find the best tacos around here?"
    when "Paris Museum Hours"
        "Bonjour! What time does the Louvre close today?"
    when "Seoul Shopping District"
        "Excuse me, which direction is Myeongdong shopping area?"
    when "NYC Theater Tickets"
        "Hi there! Any tips on getting last-minute Broadway tickets?"
    when "Berlin Nightlife"
        "Hey, which clubs would you recommend in Kreuzberg?"
    when "Tokyo Cherry Blossom Spots"
        "Could you tell me the best places to see cherry blossoms this week?"
    when "CDMX Taxi Fare"
        "Approximately how much should a taxi cost to Coyoacán?"
    when "Paris Cafe Conversation"
        "Bonjour! Is this seat taken? I'm visiting from abroad."
    when "Seoul Market Bargaining"
        "Hello! Is it possible to negotiate on the price of this?"
    when "NYC Subway Directions"
        "Excuse me, which train should I take to get to Central Park?"
    when "Berlin Hotel Services"
        "Guten Tag! Does this hotel offer laundry service?"
    else
        "Hello there! Can you help me with #{chat.subject}?"
    end

    root_message = Message.create!(
      chat: chat,
      author: first_author,
      content: root_content,
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
        # Choose message content based on chat subject
        if chat.subject == "Berlin Restaurant Recommendations"
          content = [
            "I'd recommend Zur Rose on Bergmannstraße, very authentic German food.",
            "If you like Italian, there's a great place called Malafemmena nearby.",
            "How long are you in Berlin for?",
            "Are you looking for something fancy or more casual?",
            "Do you have any dietary restrictions I should know about?",
            "Markthalle Neun has amazing street food on Thursdays!",
            "What's your budget? That will help me recommend something suitable.",
            "There's a nice Vietnamese place just around the corner.",
            "Berlin has great kebab places. Have you tried Mustafa's?",
            "The beer garden in Tiergarten is lovely if the weather is nice.",
            "If you like burgers, The Bird is very popular with tourists.",
            "Restaurant Reinstoff is excellent but you'll need a reservation.",
            "I can draw you a quick map if that helps?",
            "Are you using Google Maps? It's pretty reliable here.",
            "Does anyone in your group have allergies?"
          ].sample
        elsif chat.subject == "Tokyo Subway Directions"
          content = [
            "You need to take the Yamanote line to Shibuya. It's about 15 minutes.",
            "The subway maps have English, so it should be easy to follow.",
            "Make sure you take the express train, not the local one.",
            "You'll need to transfer at Shinjuku station.",
            "The fare will be about 220 yen each way.",
            "Be careful during rush hour, it gets very crowded.",
            "There's a Japan Rail Pass for tourists if you're traveling a lot.",
            "The last train is around midnight, so be careful not to miss it.",
            "Do you have a Suica or Pasmo card? It makes traveling much easier.",
            "The exits at Shibuya can be confusing. Look for the Hachiko exit.",
            "Trains are very punctual here, so check the timetable.",
            "Would you like me to write it down for you?",
            "The announcements are in Japanese and English on most lines.",
            "It's about a 5-minute walk from here to the nearest station.",
            "Are you going to Tokyo Tower after that? It's lovely at sunset."
          ].sample
        elsif chat.subject == "CDMX Street Food Guide"
          content = [
            "The best tacos al pastor are at El Huequito, just two blocks down.",
            "Be careful with street food if you're not used to it. Start with small portions.",
            "Try the elotes with chile and lime, they're amazing!",
            "There's a great taco stand that opens at night on the corner of Reforma.",
            "Have you tried tamales yet? There's a lady who sells them every morning.",
            "For quesadillas, go to the market. They make them fresh there.",
            "Make sure they cook the food in front of you, it's safer that way.",
            "The best time for street food is early evening, around 6pm.",
            "Try the blue corn tortillas, they're more traditional.",
            "If you like spicy food, ask for habanero salsa, but be careful!",
            "The seafood tostadas at Contramar are famous, but not exactly street food.",
            "There's a good food tour that starts in the Zócalo if you're interested.",
            "Drink bottled water or beer with your street food, not tap water.",
            "The churros at El Moro are a must-try for dessert.",
            "How spicy can you handle your food? Mexican spicy is different!"
          ].sample
        elsif chat.subject == "Paris Museum Hours"
          content = [
            "The Louvre closes at 6pm today, but on Wednesdays and Fridays it's open until 9:45pm.",
            "It's better to go early in the morning to avoid the crowds.",
            "Tuesday is when most museums in Paris are closed, so plan accordingly.",
            "Have you purchased a museum pass? It saves money if you're visiting several places.",
            "The line for security can take up to an hour at peak times.",
            "If you enter through the Carrousel du Louvre entrance, the line is usually shorter.",
            "Are you interested in any particular exhibits?",
            "The Mona Lisa is always crowded, be prepared to wait to get a good view.",
            "Musée d'Orsay is open until 6pm and has wonderful Impressionist paintings.",
            "Monday might be busy because many other museums are closed that day.",
            "The Centre Pompidou has modern art and stays open until 9pm.",
            "There's free entry on the first Sunday of each month, but it gets very crowded.",
            "Do you have your ticket already? You can buy it online to save time.",
            "Photography is allowed in most areas, but no flash please.",
            "Would you like a recommendation for a café nearby for afterward?"
          ].sample
        elsif chat.subject == "Seoul Shopping District"
          content = [
            "Myeongdong is about 10 minutes by foot in that direction. Just follow the main road.",
            "It's a great place for Korean cosmetics and street food.",
            "The prices in Myeongdong are fixed, but you can get free samples.",
            "If you want electronics, you should go to Yongsan instead.",
            "Are you looking for traditional souvenirs? Insadong might be better.",
            "The best time to go is weekday mornings when it's less crowded.",
            "Make sure to try the street food there, especially the hotteok.",
            "Many shops have tax refund services for tourists.",
            "If you like K-pop merchandise, there are several stores there.",
            "Most shops open around 10:30am and close at 10pm.",
            "You can take the subway Line 4 to Myeongdong station if you prefer.",
            "Dongdaemun is another good shopping area, especially for clothes.",
            "Do you have a specific brand or item you're looking for?",
            "The prices are generally good, especially compared to abroad.",
            "Would you like me to write down the name in Korean for you to show?"
          ].sample
        elsif chat.subject == "NYC Theater Tickets"
          content = [
            "Try the TKTS booth in Times Square for same-day discounted tickets.",
            "If you go later in the afternoon, the lines are usually shorter.",
            "There's also a lottery system for popular shows like Hamilton.",
            "What show are you interested in seeing?",
            "Some theaters have standing room tickets that are much cheaper.",
            "The Today Tix app sometimes has good last-minute deals.",
            "Student discounts are available at some theaters if you have ID.",
            "Weekday shows are usually easier to get tickets for than weekends.",
            "Have you checked the official website? Sometimes they release tickets last minute.",
            "Off-Broadway shows are less expensive and often just as good.",
            "Be careful of scalpers selling tickets on the street.",
            "If you're flexible about what to see, you'll have more options.",
            "The best shows sell out months in advance, especially for weekend performances.",
            "Broadway Week happens twice a year with 2-for-1 tickets.",
            "Rush tickets go on sale when the box office opens, but you need to line up early."
          ].sample
        elsif chat.subject == "Berlin Nightlife"
          content = [
            "Berghain is famous but very hard to get into. Dress down and don't talk in line.",
            "Watergate has great electronic music and a view of the river.",
            "Club der Visionaere is nice in summer with its outdoor area.",
            "Most clubs don't get busy until after 1am here.",
            "Kreuzberg has more alternative venues, while Mitte is more mainstream.",
            "You might want to pre-game because drinks can be expensive.",
            "Be prepared to pay a cover charge, usually around 10-15 euros.",
            "Some places have a strict door policy, don't take it personally if you don't get in.",
            "Are you looking for electronic music or something different?",
            "Tresor is in an old power plant and has a very industrial vibe.",
            "About Blank has a nice garden area for when you need a break from dancing.",
            "Many clubs open Friday night and stay open through Monday morning.",
            "If you don't want to wait in line, arrive before midnight or after 4am.",
            "It's best to check social media for events, as schedules change often.",
            "Don't take photos inside most Berlin clubs, it's strongly discouraged."
          ].sample
        elsif chat.subject == "Tokyo Cherry Blossom Spots"
          content = [
            "Ueno Park is one of the most popular spots, but it gets very crowded.",
            "Shinjuku Gyoen has later-blooming trees, so good if you missed peak bloom elsewhere.",
            "Chidorigafuchi is beautiful with the moat around the Imperial Palace.",
            "The blossoms usually peak in late March to early April, but it varies year to year.",
            "Nakameguro has a lovely canal lined with cherry trees, beautiful at night when lit up.",
            "Yoyogi Park is less crowded and has nice areas for picnics under the trees.",
            "Are you planning to do hanami? Bring a tarp to sit on if so.",
            "The weather forecast says the blooms might come early this year.",
            "I recommend going early morning to avoid crowds, especially on weekends.",
            "Sumida Park along the river has a nice view with Tokyo Skytree in the background.",
            "Some places have night illuminations, which create a magical atmosphere.",
            "If you're here for a few days, try visiting different spots to compare.",
            "Take the Yamanote line to see different areas easily.",
            "The blossoms only last about a week once they're in full bloom.",
            "If it rains, the petals fall more quickly, so try to go as soon as you can."
          ].sample
        elsif chat.subject == "CDMX Taxi Fare"
          content = [
            "To Coyoacán, it should be around 150-200 pesos depending on traffic.",
            "I recommend using Uber or Didi instead of street taxis for safety.",
            "Make sure the taxi uses a meter, or agree on the price before getting in.",
            "The pink and white taxis are official and safer to use.",
            "Traffic can be really bad during rush hour, so it might cost more then.",
            "It's about a 30-minute ride without traffic, but could be an hour during rush hour.",
            "The metro is much cheaper if you're comfortable using it.",
            "Sitio taxis from designated stands are safer than hailing one on the street.",
            "Do you have the exact address in Coyoacán? That will help estimate better.",
            "Keep small bills with you for paying taxis, they rarely have change for large bills.",
            "If you speak Spanish, you might get a better rate.",
            "The Turibus also goes to Coyoacán if you prefer a sightseeing option.",
            "Avoid taxis that don't look official, even if they're cheaper.",
            "It's worth the extra cost to use a secure taxi service, especially at night.",
            "Would you like me to call a taxi for you from a reputable company?"
          ].sample
        elsif chat.subject == "Paris Cafe Conversation"
          content = [
            "Please, sit down! Where are you visiting from?",
            "The coffee here is excellent. I recommend trying a café crème.",
            "How long are you staying in Paris?",
            "Is this your first time in Paris? You must visit the Eiffel Tower at night.",
            "The pastries here are delicious, especially the pain au chocolat.",
            "Have you been to Montmartre yet? The view of the city is spectacular.",
            "Parisians usually take their time at cafés, no need to rush.",
            "If you like museums, the Musée d'Orsay is less crowded than the Louvre.",
            "Do you speak French? Your accent is quite good!",
            "The weather has been unusually nice lately, very fortunate for sightseeing.",
            "I recommend the prix fixe menu if you're planning to have lunch here.",
            "Are you traveling alone or with friends?",
            "The waiter won't bring your bill until you ask for it - that's normal here.",
            "What has been your favorite part of Paris so far?",
            "If you have time, take a boat tour on the Seine. It's a lovely way to see the city."
          ].sample
        elsif chat.subject == "Seoul Market Bargaining"
          content = [
            "Yes, at markets like Namdaemun or Dongdaemun, bargaining is expected.",
            "Start by offering about 70% of the asking price, then negotiate from there.",
            "It helps if you buy multiple items from the same vendor.",
            "Smiling and being friendly goes a long way in getting a good price.",
            "Having a calculator or using your phone to show numbers helps overcome language barriers.",
            "Early morning or late evening tends to be better for bargaining.",
            "Department stores and brand shops have fixed prices, no negotiation there.",
            "Is there a specific item you're looking at?",
            "If you walk away, they might call you back with a better offer.",
            "Cash usually gets you a better deal than credit cards.",
            "Learn a few basic Korean phrases - vendors appreciate the effort.",
            "Quality varies a lot, so check items carefully before purchasing.",
            "Some vendors speak a little English, especially in tourist areas.",
            "If you see the same item at multiple stalls, check all prices before bargaining.",
            "Don't be too aggressive in bargaining, aim for a fair price for both sides."
          ].sample
        elsif chat.subject == "NYC Subway Directions"
          content = [
            "Take the uptown A, C, or D train to 59th Street-Columbus Circle, then walk east.",
            "The subway map can be confusing, but look for the colored lines.",
            "Make sure you're going uptown, not downtown.",
            "Trains run less frequently on weekends due to maintenance.",
            "You need to buy a MetroCard from the machine before entering.",
            "Express trains skip many stations, so check if it stops where you need to go.",
            "Central Park is huge - which part are you trying to get to specifically?",
            "The subway is 24/7, but late-night service is limited.",
            "If you're not comfortable with the subway, there's also buses or a short taxi ride.",
            "It's about $2.75 per ride, but you can get a day pass if you're using it a lot.",
            "The entrances are marked with green lamps for always open, red for sometimes closed.",
            "Download the MTA app, it shows real-time train arrivals.",
            "Be careful of service changes, especially on weekends.",
            "During rush hour it gets very crowded, try to avoid 8-9:30am and 5-6:30pm.",
            "Holding the doors is a major no-no and will get you nasty looks from locals."
          ].sample
        elsif chat.subject == "Berlin Hotel Services"
          content = [
            "Ja, we offer laundry service. Just bring your clothes to the front desk before 10am.",
            "It costs €3 per shirt and €5 for pants. We can add it to your room bill.",
            "Your clothes will be ready by 6pm the same day, or the next morning if dropped off later.",
            "We also have a self-service laundry room in the basement if you prefer.",
            "Do you need any other services? We have room service, spa, and gym facilities.",
            "Breakfast is served from 6:30am to 10:30am on weekdays, until 11am on weekends.",
            "The hotel WiFi password is in your room information folder.",
            "We can arrange airport transportation if you need it.",
            "The concierge can help you with restaurant reservations or tour bookings.",
            "Our spa is open from 7am to 10pm daily, reservations are recommended.",
            "Room cleaning happens between 9am and 3pm, you can request a specific time.",
            "We have adapters available at the front desk if you need one.",
            "Is there anything else I can help you with during your stay?",
            "Check-out time is noon, but we can offer late check-out for an additional fee.",
            "Would you like us to make a dinner reservation for you tonight?"
          ].sample
        else
          content = [
            "I'm not sure I understand what you're asking.",
            "Could you repeat that please?",
            "Let me check for you.",
            "That's an interesting question!",
            "I'm happy to help with that.",
            "One moment while I think about that.",
            "Have you tried asking someone else?",
            "I believe I can assist with that.",
            "That's a common question from visitors.",
            "Let me give you my local perspective on that.",
            "I'm not originally from here, but I've lived here for years.",
            "That's actually quite complicated to explain.",
            "The answer depends on what exactly you're looking for.",
            "I wish I could be more helpful with that.",
            "That's a great question, I'm glad you asked!"
          ].sample
        end
      elsif current_time < 3.months.ago
        # Generic older messages for travel conversations
        content = [
          "Thank you so much for your help!",
          "That's exactly what I was looking for.",
          "Do you speak English?",
          "How do I say 'thank you' in the local language?",
          "Could you write that down for me?",
          "Is it far from here?",
          "Do you accept credit cards?",
          "Is it safe to walk there at night?",
          "What time does it open?",
          "Is there an entrance fee?",
          "Are there any good photo spots nearby?",
          "Do you have a recommendation for dinner?",
          "Where's the nearest bathroom?",
          "Is tap water safe to drink here?",
          "How much should I tip?",
          "Do you know if there's WiFi here?",
          "What's the local specialty I should try?",
          "Can you recommend something off the tourist path?",
          "How do I get back to my hotel from here?",
          "Are there any local events happening today?",
          "What's the best time to visit to avoid crowds?",
          "I really appreciate your kindness!",
          "Do most people here understand English?",
          "Is this price normal or am I getting the tourist rate?",
          "Could you call a taxi for me please?"
        ].sample
      elsif current_time < 1.month.ago
        # More recent messages for travel conversations
        content = [
          "I'm visiting again next month, would love to meet up!",
          "I tried what you recommended last time - it was amazing!",
          "Do you know if things have changed since my last visit?",
          "I've been practicing the phrases you taught me.",
          "I showed my friends the photos from where you recommended.",
          "I'm bringing my family this time, any additional suggestions?",
          "Is that new place worth checking out?",
          "I've been telling everyone about this hidden gem you showed me.",
          "Have the prices changed much since last year?",
          "I'm back in town! Remember me from last time?",
          "I've been craving that food ever since I left.",
          "I'm staying in a different area this time, near the river.",
          "That museum you recommended was the highlight of my trip!",
          "Do you still work in this area? I promised I'd come back.",
          "I learned so much about the culture from our conversation!"
        ].sample
      else
        # Longer, paragraph-style messages 30% of the time
        content = [
          "I've been exploring the city for a few days now and I'm absolutely loving it! The architecture is stunning and the food has been incredible. I'm trying to find some less touristy spots though. Do you have any recommendations for places where locals like to hang out? I'd love to experience something more authentic than what's in the guidebooks.",

          "This is my first time traveling solo and I'm a bit nervous about getting around. I've heard that the public transportation system here is really efficient, but I'm struggling to understand the ticketing system. Is there a day pass or something I can buy that would be more economical than single tickets? Also, are there any neighborhoods I should avoid, especially at night?",

          "Thank you so much for all your help yesterday! I followed your advice and went to that local restaurant you recommended. The food was amazing and the owner was so friendly - he even gave us a free dessert when he found out we were visitors! I was wondering if you could help me again today. I'm looking for somewhere to buy authentic souvenirs that aren't overpriced tourist traps.",

          "I'm trying to find a balance between seeing the famous attractions and experiencing daily life here. Yesterday I visited the main museum and it was spectacular, but today I'd like to just wander and get lost in the city. Is this area good for walking around? Are there any interesting markets or street food areas nearby that would be worth exploring?",

          "We're planning our last day here tomorrow and can't decide what to do! We've already seen the major attractions, but feel like we're missing something important. If you had just one day left in this city, what would you do? We're particularly interested in history and local cuisine, but open to any suggestions you might have.",

          "I've been having trouble finding vegetarian options that are also authentic local cuisine. Most restaurants seem to focus heavily on meat dishes. Do you know any places that offer traditional food but with good vegetarian choices? I don't want to just eat at international restaurants - I really want to try the local specialties, just without meat if possible.",

          "I'm staying here for about a month to improve my language skills. Do you know of any casual meetups or language exchange events where I could practice with locals? I'm also looking for a good café with reliable wifi where I could spend a few hours working and studying. Somewhere not too noisy but with a nice atmosphere would be perfect.",

          "My flight home isn't until late tomorrow night, and I have to check out of my accommodation by noon. Do you have any suggestions for what I could do with my luggage during the day? And maybe recommendations for how to spend those last hours? I'd rather not just sit at the airport all day if there's a better alternative.",

          "I'm traveling with my elderly parents who have some mobility issues. We're looking for interesting cultural experiences that don't involve too much walking or standing. Are there any seated performances of traditional music or dance that you would recommend? Or perhaps museums or galleries that are particularly accessible?",

          "I've been collecting recommendations for my next trip and would love your input as a local. If you were going to create a perfect three-day itinerary for someone visiting for the first time, what would it include? I'm especially interested in hidden gems and authentic experiences that really capture the essence of this place and its culture."
        ].sample
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
