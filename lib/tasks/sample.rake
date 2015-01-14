namespace :facade do
  desc 'Add sample Facade layouts, pages, etc'
  task :sample => :environment do
    store = Facade::Store.new

    [Facade::Resource, Facade::Layout].each do |klass|
      key = "#{store.send(:prefix, klass)}-id"
      store.redis.del(key)
    end

    layout = Facade::Layout.new( name: 'Sample Page',
                                 type: "layout",
                                 elements: [{
                                   type: 'group',
                                    required: false,
                                    elements: [
                                      {type: "text",
                                       name: "Page Title",
                                       required: false,
                                       template: "<h1><%= element.value %></h1>\n"},
                                      {
                                       type: "image_group",
                                       name: "scroller_images",
                                       required: false,
                                       min_children: 2,
                                       max_children: 6,
                                       template:
                                        "<div id=\"scroller\">\n<%= element.render_children %>\n</div>\n",
                                       elements: [{
                                          name: "Image 1",
                                          template: "  <img src=\"<%= element.src %>\" alt=\"<%= element.alt %>\">",
                                          type: "image"},
                                         {
                                          name: "Image 2",
                                          template: "  <img src=\"<%= element.src %>\" alt=\"<%= element.alt %>\">",
                                          type: "image"}]},
                                      {
                                       type: "data_group",
                                       required: false,
                                       elements: [{
                                          required: false,
                                          template:
                                           "<div class=\"product\">\n  <h4><%= element.value['name'] %></h4>\n  <strong><%= element.value['price'] %></strong>\n  <p><%= element.value['description'] %></p>\n</div>\n",
                                          type: "datum"},
                                         {
                                          required: false,
                                          template:
                                           "<div class=\"product\">\n  <h4><%= element.value['name'] %></h4>\n  <strong><%= element.value['price'] %></strong>\n  <p><%= element.value['description'] %></p>\n</div>\n",
                                          type: "datum"}]}]
                                    }])

    # persist layout
    store.save(layout)
    puts "Created #{store.get_all(Facade::Layout).size} Layout"


    # create and populate a page from the layout above
    page = layout.build_resource
    page.slug = '/new_products'
    # Text Item within a generic group
    page.elements[0].elements[0].value = "New Products"

    # images within an image group
    page.elements[0].elements[1].elements[0].src = "http://placehold.it/150&text=Image+1"
    page.elements[0].elements[1].elements[0].alt = "A lovely image"

    page.elements[0].elements[1].elements[1].src = "http://placehold.it/150&text=Image+2"
    page.elements[0].elements[1].elements[1].alt = "Another lovely image"

    # data items with a data group
    page.elements[0].elements[2].elements[0].value = {name: "Ruby Mug", price: 9.99, description: "This is a mug."}
    page.elements[0].elements[2].elements[1].value = {name: "Rails Tote", price: 12.99, description: "This is a tote."}

    # persist page
    store.save(page)

    puts "Created #{store.get_all(Facade::Resource).size} Resource"
  end
end
