<% @youtube_data.items.each do |item| %>
  <% snippet = item.snippet %>
  <p><%= snippet.title %></p>
  <p><%= snippet.published_at %><%= snippet.channel_title %></p>
  <div><iframe width="560" height="315" src="https://www.youtube.com/embed/<%= item.id.video_id %>" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
<% end %>