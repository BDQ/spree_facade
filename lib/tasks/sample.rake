namespace :facade do
  desc 'Add sample Facade layouts, pages, etc'
  task :sample => :environment do
    store = Facade::Store.new

    [Facade::Page, Facade::Layout].each do |klass|
      key = "#{store.send(:prefix, klass)}-id"
      store.redis.del(key)
    end

    layout = Facade::Layout.new( name: 'Sample Page',
                                 type: "layout",
                                 fields: [{
                                   type: 'group',
                                    required: false,
                                    fields: [
                                      {type: "text",
                                       name: "Page Title",
                                       required: false,
                                       template: "<h1><%= field.value %></h1>\n"},
                                      {
                                       type: "image_group",
                                       name: "scroller_images",
                                       required: false,
                                       min_children: 2,
                                       max_children: 6,
                                       template:
                                        "<div id=\"scroller\">\n<%= field.render_children %>\n</div>\n",
                                       fields: [{
                                          name: "Image 1",
                                          template: "  <img src=\"<%= field.src %>\" alt=\"<%= field.alt %>\">",
                                          type: "image"},
                                         {
                                          name: "Image 2",
                                          template: "  <img src=\"<%= field.src %>\" alt=\"<%= field.alt %>\">",
                                          type: "image"}]},
                                      {
                                       type: "data_group",
                                       required: false,
                                       fields: [{
                                          required: false,
                                          template:
                                           "<div class=\"product\">\n  <h4><%= field.value['name'] %></h4>\n  <strong><%= field.value['price'] %></strong>\n  <p><%= field.value['description'] %></p>\n</div>\n",
                                          type: "datum"},
                                         {
                                          required: false,
                                          template:
                                           "<div class=\"product\">\n  <h4><%= field.value['name'] %></h4>\n  <strong><%= field.value['price'] %></strong>\n  <p><%= field.value['description'] %></p>\n</div>\n",
                                          type: "datum"}]}]
                                    }])

    # persist layout
    store.save(layout)
    puts "Created #{store.get_all(Facade::Layout).size} Layout"


    # create and populate a page from the layout above
    page = layout.build_page
    page.slug = '/new_products'
    # Text Item within a generic group
    page.fields[0].fields[0].value = "New Products"

    # images within an image group
    page.fields[0].fields[1].fields[0].src = "http://placehold.it/150&text=Image+1"
    page.fields[0].fields[1].fields[0].alt = "A lovely image"

    page.fields[0].fields[1].fields[1].src = "http://placehold.it/150&text=Image+2"
    page.fields[0].fields[1].fields[1].alt = "Another lovely image"

    # data items with a data group
    page.fields[0].fields[2].fields[0].value = {name: "Ruby Mug", price: 9.99, description: "This is a mug."}
    page.fields[0].fields[2].fields[1].value = {name: "Rails Tote", price: 12.99, description: "This is a tote."}

    # persist page
    store.save(page)

    puts "Created #{store.get_all(Facade::Page).size} Page"
  end
end
