# Blazer Query Seeds for Analytics

# Skip if queries already exist
return if Blazer::Query.any?

queries = [
  {
    name: "Daily Active Users",
    statement: <<~SQL
      SELECT#{' '}
        DATE(created_at) as date,
        COUNT(DISTINCT author_id) as active_users
      FROM messages
      WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
      GROUP BY DATE(created_at)
      ORDER BY date DESC
    SQL
  },
  {
    name: "Messages by Language",
    statement: <<~SQL
      SELECT#{' '}
        l.name as language,
        COUNT(*) as message_count
      FROM messages m
      JOIN languages l ON m.original_language_id = l.id
      GROUP BY l.name
      ORDER BY message_count DESC
    SQL
  },
  {
    name: "Translation Volume by Day",
    statement: <<~SQL
      SELECT#{' '}
        DATE(time) as date,
        COUNT(*) as translations
      FROM ahoy_events
      WHERE name = 'translation_created'
      AND time >= CURRENT_DATE - INTERVAL '30 days'
      GROUP BY DATE(time)
      ORDER BY date DESC
    SQL
  },
  {
    name: "Most Active Chats",
    statement: <<~SQL
      SELECT#{' '}
        c.id,
        c.token,
        c.subject,
        COUNT(m.id) as message_count,
        MAX(m.created_at) as last_message_at
      FROM chats c
      LEFT JOIN messages m ON c.id = m.chat_id
      GROUP BY c.id, c.token, c.subject
      ORDER BY message_count DESC
      LIMIT 20
    SQL
  },
  {
    name: "User Language Distribution",
    statement: <<~SQL
      SELECT#{' '}
        l.name as preferred_language,
        COUNT(*) as user_count,
        ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 2) as percentage
      FROM users u
      JOIN languages l ON u.preferred_language_id = l.id
      GROUP BY l.name
      ORDER BY user_count DESC
    SQL
  },
  {
    name: "API Usage Cost Estimate",
    statement: <<~SQL
      WITH translation_costs AS (
        SELECT#{' '}
          COUNT(*) as translation_count,
          SUM((properties->>'content_length')::int) as total_chars
        FROM ahoy_events
        WHERE name = 'translation_created'
      )
      SELECT#{' '}
        translation_count,
        total_chars,
        ROUND(total_chars / 1000000.0, 2) as million_chars,
        ROUND((total_chars / 1000000.0) * 15, 2) as estimated_cost_usd
      FROM translation_costs
    SQL
  },
  {
    name: "Hourly Usage Pattern",
    statement: <<~SQL
      SELECT#{' '}
        EXTRACT(hour FROM created_at) as hour,
        COUNT(*) as messages
      FROM messages
      WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
      GROUP BY EXTRACT(hour FROM created_at)
      ORDER BY hour
    SQL
  },
  {
    name: "New Users by Day",
    statement: <<~SQL
      SELECT#{' '}
        DATE(created_at) as date,
        COUNT(*) as new_users
      FROM users
      WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
      GROUP BY DATE(created_at)
      ORDER BY date DESC
    SQL
  },
  {
    name: "Translation Language Pairs",
    statement: <<~SQL
      SELECT#{' '}
        properties->>'from_language' as from_lang,
        properties->>'to_language' as to_lang,
        COUNT(*) as translation_count
      FROM ahoy_events
      WHERE name = 'translation_created'
      GROUP BY from_lang, to_lang
      ORDER BY translation_count DESC
      LIMIT 20
    SQL
  },
  {
    name: "Chat Participation",
    statement: <<~SQL
      SELECT#{' '}
        c.id,
        c.token,
        c.subject,
        COUNT(DISTINCT cu.user_id) as participant_count,
        c.created_at
      FROM chats c
      LEFT JOIN chat_users cu ON c.id = cu.chat_id
      GROUP BY c.id, c.token, c.subject, c.created_at
      ORDER BY c.created_at DESC
      LIMIT 50
    SQL
  }
]

admin = Admin.first
if admin
  queries.each do |query_data|
    Blazer::Query.find_or_create_by!(name: query_data[:name]) do |query|
      query.statement = query_data[:statement]
      query.creator_id = admin.id
    end
  end

  puts "Created #{queries.length} Blazer queries"
else
  puts "No admin found - skipping Blazer queries"
end
