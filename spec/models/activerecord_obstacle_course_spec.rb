require 'rails_helper'
require 'pry'

describe 'ActiveRecord Obstacle Course' do
  before :each do
    @user_1 = create(:user, name: 'Megan')
    @user_2 = create(:user, name: 'Brian')
    @user_3 = create(:user, name: 'Ian')

    # # DO NOT CHANGE THE ORDER OF THIS DATA TO MAKE TESTS PASS
    @item_1  = create(:item, name: 'Apples')
    @item_4  = create(:item, name: 'Bananas')
    @item_9  = create(:item, name: 'Carrots')
    @item_2  = create(:item, name: 'Dumplings')
    @item_5  = create(:item, name: 'Eggplant')
    @item_10 = create(:item, name: 'Figs')
    @item_3  = create(:item, name: 'Grapes')
    @item_6  = create(:item, name: 'Honey')
    @item_8  = create(:item, name: 'Ice Cream')
    @item_7  = create(:item, name: 'Jalapeno')

    # DO NOT CHANGE THE ORDER OF THIS DATA TO MAKE TESTS PASS
    @order_3 = create(:order, amount: 500, items: [@item_2, @item_3, @item_4, @item_5], user: @user_3)
    @order_11 = create(:order, amount: 800, items: [@item_5, @item_4, @item_7, @item_9], user: @user_2)
    @order_5 = create(:order, amount: 550, items: [@item_1, @item_5, @item_4, @item_7], user: @user_2)
    @order_2 = create(:order, amount: 300, items: [@item_1, @item_1, @item_2, @item_3], user: @user_2)
    @order_1 = create(:order, amount: 200, items: [@item_1, @item_1, @item_2, @item_3], user: @user_1)
    @order_13 = create(:order, amount: 870, items: [@item_2, @item_3, @item_4, @item_7], user: @user_1)
    @order_8 = create(:order, amount: 700, items: [@item_2, @item_3, @item_8, @item_9], user: @user_2)
    @order_6 = create(:order, amount: 580, items: [@item_5, @item_8, @item_9, @item_10], user: @user_1)
    @order_10 = create(:order, amount: 750, items: [@item_1, @item_5, @item_4, @item_7], user: @user_1)
    @order_15 = create(:order, amount: 1000, items: [@item_1, @item_4, @item_5, @item_7], user: @user_3)
    @order_4 = create(:order, amount: 501, items: [@item_1, @item_1, @item_2, @item_3], user: @user_1)
    @order_9 = create(:order, amount: 649, items: [@item_3, @item_4, @item_8, @item_10], user: @user_3)
    @order_14 = create(:order, amount: 900, items: [@item_3, @item_5, @item_8, @item_9], user: @user_2)
    @order_7 = create(:order, amount: 600, items: [@item_1, @item_5, @item_7, @item_9], user: @user_1)
    @order_12 = create(:order, amount: 850, items: [@item_1, @item_3, @item_7, @item_10], user: @user_3)
  end


# The items and orders above were created out of order *ON PURPOSE* -- there are many ways to solve
# these problems, but we found that students were writing incorrect queries that still passed because
# they were relying on the order that these things were created.
#
# If you attempt to re-order these objects, many (or all) of the tests will not function correctly
# and you will be asked to start over.
#
# Here are the docs associated with ActiveRecord queries: http://guides.rubyonrails.org/active_record_querying.html

# ----------------------


  it '1. finds orders by amount' do
    # ----------------------- Using Ruby -------------------------
    orders_of_500 = Order.all.select { |order| order.amount == 500 }
    orders_of_200 = Order.all.select { |order| order.amount == 200 }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    orders_of_500 = Order.where(amount: 500)
    orders_of_200 = Order.where(amount: 200)
    # ------------------------------------------------------------

    # Expectation
    expect(orders_of_500.count).to eq(1)
    expect(orders_of_200.count).to eq(1)
  end

  it '2. finds order id of smallest order' do
    # ----------------------- Using Raw SQL ----------------------
    order_id = ActiveRecord::Base.connection.execute('SELECT id FROM orders ORDER BY amount ASC LIMIT 1').first['id']
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # Your solution should not contain the ID of the order anywhere
    order_id = Order.order(:amount).first.id
    # ------------------------------------------------------------

    # Expectation
    expect(order_id).to eq(@order_1.id)
  end

  it '3. finds order id of largest order' do
    # ----------------------- Using Raw SQL ----------------------
    order_id = ActiveRecord::Base.connection.execute('SELECT id FROM orders ORDER BY amount DESC LIMIT 1').first['id']
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # Your solution should not contain the ID of the order anywhere
    order_id = Order.order(amount: :desc).first.id
    # ------------------------------------------------------------

    # Expectation
    expect(order_id).to eq(@order_15.id)
  end

  it '4. finds orders of multiple amounts' do
    # ----------------------- Using Ruby -------------------------
    orders_of_500_and_700 = Order.all.select do |order|
      order.amount == 500 || order.amount == 700
    end

    orders_of_700_and_1000 = Order.all.select do |order|
      order.amount == 700 || order.amount == 1000
    end
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # orders_of_500_and_700 = Order.where(amount: 500).or(Order.where(amount: 700))
    # orders_of_700_and_1000 = Order.where(amount: 700).or(Order.where(amount: 1000))
    orders_of_500_and_700 = Order.where(amount: [500, 700])
    orders_of_500_and_700 = Order.where(amount: [700, 1000])
    # ------------------------------------------------------------

    # Expectation
    expect(orders_of_500_and_700.count).to eq(2)
    expect(orders_of_700_and_1000.count).to eq(2)
  end

  it '5. finds multiple items by id' do
    ids_to_find = [@item_1.id, @item_2.id, @item_4.id]
    expected_objects = [@item_1, @item_4, @item_2]

    # ----------------------- Using Ruby -------------------------
    items = Item.all.select { |item| ids_to_find.include?(item.id) }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    items = Item.find(ids_to_find).sort
    # ------------------------------------------------------------

    # Expectation
    expect(items).to eq(expected_objects)
  end

  it '6. finds multiple orders by id' do
    ids_to_find = [@order_1.id, @order_3.id, @order_5.id, @order_7.id]

    # ----------------------- Using Ruby -------------------------
    # orders = Order.all.select { |order| ids_to_find.include?(order.id) }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    orders = Order.order(:id).find(ids_to_find)
    # ------------------------------------------------------------

    # Expectation
    expect(orders).to eq([@order_3, @order_5, @order_1, @order_7])
  end

  it '7. finds orders with an amount between 700 and 1000' do
    expected_result = [@order_11, @order_13, @order_8, @order_10, @order_15, @order_14, @order_12]
    # ----------------------- Using Ruby -------------------------
    orders_between_700_and_1000 = Order.all.select { |order| order.amount >= 700 && order.amount <= 1000 }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    #is this correct? .where returns relations, not an array, but test passes.
    orders_between_700_and_1000  = Order.where(amount: 700 ..1000)
    # ------------------------------------------------------------

    # Expectation
    expect(orders_between_700_and_1000).to eq(expected_result)
  end

  it '8. finds orders with an amount less than 550' do
    expected_result = [@order_3, @order_2, @order_1, @order_4]

    # ----------------------- Using Ruby -------------------------
    orders_less_than_550 = Order.all.select { |order| order.amount < 550 }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    orders_less_than_550  = Order.where("amount < ?", 550)
    # ------------------------------------------------------------

    # Expectation
    expect(orders_less_than_550).to eq(expected_result)
  end







  # ========================
  # You should be approximately here by the end of Week 1
  # ========================








  it '9. finds orders for a user' do
    expected_result = [@order_3, @order_15, @order_9, @order_12]

    # ----------------------- Using Ruby -------------------------
    orders_of_user_3 = Order.all.select { |order| order.user_id == @user_3.id }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    orders_of_user_3 = Order.where(user_id: @user_3.id)
    # ------------------------------------------------------------

    # Expectation
    expect(orders_of_user_3).to eq(expected_result)
  end

  it '10. sorts the orders from most expensive to least expensive' do
    expected_result = [
      @order_15, @order_14, @order_13, @order_12, @order_11,
      @order_10, @order_8, @order_9, @order_7, @order_6,
      @order_5, @order_4, @order_3, @order_2, @order_1
    ]

    # ----------------------- Using Ruby -------------------------
    orders = Order.all.sort_by { |order| order.amount }.reverse
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    orders = Order.order(amount: :desc)
    # ------------------------------------------------------------

    # Expectation
    expect(orders).to eq(expected_result)
  end

  it '11. sorts the orders from least expensive to most expensive' do
    expected_result = [
      @order_1, @order_2, @order_3, @order_4, @order_5,
      @order_6, @order_7, @order_9, @order_8, @order_10,
      @order_11, @order_12, @order_13, @order_14, @order_15
    ]

    # ----------------------- Using Ruby -------------------------
    orders = Order.all.sort_by { |order| order.amount }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    orders = Order.order(:amount)
    # ------------------------------------------------------------

    # Expectation
    expect(orders).to eq(expected_result)
  end

  it '12. should return all items except items 2, 5 and 6' do
    items_not_included = [@item_2, @item_5, @item_6]
    expected_result = [
      @item_1, @item_4, @item_9, @item_10,
      @item_3, @item_8, @item_7
    ]

    # ----------------------- Using Ruby -------------------------
    items = Item.all.map { |item| item unless items_not_included.include?(item) }.compact
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    items = Item.where.not(id: items_not_included)
    # ------------------------------------------------------------

    # Expectation
    expect(items).to eq(expected_result)
  end

  it "13. groups an order's items by name" do
    expected_result = [@item_4, @item_2, @item_5, @item_3]
    # ----------------------- Using Ruby -------------------------
    order = Order.find(@order_3.id)
    grouped_items = order.items.sort_by { |item| item.name }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    grouped_items = Order.find(@order_3.id).items.order(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(grouped_items).to eq(expected_result)
  end

  it '14. plucks all values from one column' do
    expected_result = ['Apples', 'Bananas', 'Carrots', 'Dumplings', 'Eggplant', 'Figs', 'Grapes', 'Honey', 'Ice Cream', 'Jalapeno']

    # ----------------------- Using Ruby -------------------------
    names = Item.all.map(&:name)
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    names = Item.pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(names).to eq(expected_result)
  end

  it '15. gets all item names associated with all orders' do
    expected_result = [
      'Dumplings', 'Grapes', 'Bananas', 'Eggplant',
      'Eggplant', 'Bananas', 'Jalapeno', 'Carrots',
      'Apples', 'Eggplant', 'Bananas', 'Jalapeno',
      'Apples', 'Dumplings', 'Grapes', 'Apples',
      'Apples', 'Dumplings', 'Grapes', 'Apples',
      'Dumplings', 'Grapes', 'Bananas', 'Jalapeno',
      'Dumplings', 'Grapes', 'Ice Cream', 'Carrots',
      'Eggplant', 'Ice Cream', 'Carrots', 'Figs',
      'Apples', 'Eggplant', 'Bananas', 'Jalapeno',
      'Apples', 'Bananas', 'Eggplant', 'Jalapeno',
      'Apples', 'Dumplings', 'Grapes', 'Apples',
      'Grapes', 'Bananas', 'Ice Cream', 'Figs',
      'Grapes', 'Eggplant', 'Ice Cream', 'Carrots',
      'Apples', 'Eggplant', 'Jalapeno', 'Carrots',
      'Apples', 'Grapes', 'Jalapeno', 'Figs',
    ]

    # ----------------------- Using Ruby -------------------------
    names = Order.all.map do |order|
      if order.items
        order.items.map { |item| item.name }
      end
    end

    names = names.flatten
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    names = Order.joins(:items).pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(names).to eq(expected_result)
  end






# ========================
# You should be approximately here by the end of Week 2
# ========================






  it '16. returns the names of users who ordered one specific item' do
    expected_result = [@user_2.name, @user_3.name, @user_1.name]

    # ----------------------- Using Raw SQL-----------------------
    users = ActiveRecord::Base.connection.execute("
      select
        distinct users.name
      from users
        join orders on orders.user_id=users.id
        join order_items ON order_items.order_id=orders.id
      where order_items.item_id=#{@item_8.id}
      ORDER BY users.name")
    users = users.map {|u| u['name']}
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    users = User.joins(orders: [:items]).where("items.id = ?", @item_8.id).distinct.order(:name).pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(users).to eq(expected_result)
  end

  it '17. returns the name of items associated with a specific order' do
    expected_result = ['Apples', 'Grapes', 'Jalapeno', 'Figs']

    # ----------------------- Using Ruby -------------------------
    names = Order.last.items.all.map(&:name)
    names.sort_by! { |x| x[/\d+/].to_i }
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    Order.last.items.pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(names).to eq(expected_result)
  end

  it '18. returns the names of items for a users order' do
    expected_result = ['Grapes', 'Bananas', 'Ice Cream', 'Figs']

    # ----------------------- Using Ruby -------------------------
    items_for_user_3_third_order = []
    grouped_orders = []
    Order.all.each do |order|
      if order.items
        grouped_orders << order if order.user_id == @user_3.id
      end
    end
    grouped_orders.each_with_index do |order, idx|
      items_for_user_3_third_order = order.items.map(&:name) if idx == 2
    end
    # ------------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    # items_for_user_3_third_order = Order.where("orders.user_id" => @user_3).group(:id)[2].items.pluck(:name)
    items_for_user_3_third_order = Order.where(user: @user_3).third.items.pluck(:name)
    # ------------------------------------------------------------

    # Expectation
    expect(items_for_user_3_third_order).to eq(expected_result)
  end

  it '19. returns the average amount for all orders' do
    # ---------------------- Using Ruby -------------------------
    average = (Order.all.map(&:amount).inject(:+)) / (Order.count)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    average = Order.average(:amount)
    # ------------------------------------------------------------

    # Expectation
    expect(average).to eq(650)
  end

  it '20. returns the average amount for all orders for one user' do
    # ---------------------- Using Ruby -------------------------
    orders = Order.all.map do |order|
      order if order.user_id == @user_3.id
    end.select{|i| !i.nil?}

    average = (orders.map(&:amount).inject(:+)) / (orders.count)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ----------------------
    # Solution goes here
    average = Order.where(user: @user_3).average(:amount)
    # average = @user_3.orders.average(:amount)
    # ------------------------------------------------------------

    # Expectation
    expect(average.to_i).to eq(749)
  end






# ========================
# You should be approximately here by the end of Week 3
# ========================






  it '21. calculates the total sales' do
    # ---------------------- Using Ruby -------------------------
    total_sales = Order.all.map(&:amount).inject(:+)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ---------------------
    # Solution goes here
    total_sales = Order.sum(:amount)
    # -----------------------------------------------------------

    # Expectation
    expect(total_sales).to eq(9750)
  end

  it '22. calculates the total sales for all but one user' do
    # ---------------------- Using Ruby -------------------------
    orders = Order.all.map do |order|
      order if order.user_id != @user_2.id
    end.select{|i| !i.nil?}
    total_sales = orders.map(&:amount).inject(:+)
    # -----------------------------------------------------------

    # ------------------ Using ActiveRecord ---------------------
    # Solution goes here
    total_sales = Order.where.not(user_id: @user_2).sum(:amount)
    # -----------------------------------------------------------

    # Expectation
    expect(total_sales).to eq(6500)
  end

  it '23. returns all orders which include item_4' do
    expected_result = [@order_3, @order_11, @order_5, @order_13, @order_10, @order_15, @order_9]

    # ------------------ Inefficient Solution -------------------
    order_ids = OrderItem.where(item_id: @item_4.id).map(&:order_id)
    orders = order_ids.map { |id| Order.find(id) }
    # -----------------------------------------------------------

    # ------------------ Improved Solution ----------------------
    #  Solution goes here
    orders = Order.joins(:items).where("items.id = ?", @item_4.id)
    # -----------------------------------------------------------

    # Expectation
    expect(orders).to eq(expected_result)
  end

  it '24. returns all orders for user 2 which include item_4' do
    expected_result = [@order_11, @order_5]

    # ------------------ Inefficient Solution -------------------
    orders = Order.where(user: @user_2)
    order_ids = OrderItem.where(order_id: orders, item: @item_4).map(&:order_id)
    orders = order_ids.map { |id| Order.find(id) }
    # -----------------------------------------------------------

    # ------------------ Improved Solution ----------------------
    #  Solution goes here
    orders = Order.where(user_id: @user_2.id).joins(:items).where("items.id = ?", @item_4.id)
    # -----------------------------------------------------------

    # Expectation
    expect(orders).to eq(expected_result)
  end

  it '25. returns items that are associated with one or more orders' do
    unordered_item = Item.create(name: 'Unordered Item')
    expected_result = [@item_1, @item_4, @item_9, @item_2, @item_5, @item_10, @item_3, @item_8, @item_7]

    # ----------------------- Using Ruby -------------------------
    items = Item.all

    ordered_items = items.map do |item|
      item if item.orders.present?
    end

    ordered_items = ordered_items.compact
    # ------------------------------------------------------------

    # ------------------ ActiveRecord Solution ----------------------
    # Solution goes here
    # binding.pry
    ordered_items = Item.joins(:orders).distinct(:item_id).order(:name)
    # ---------------------------------------------------------------

    # Expectations
    expect(ordered_items).to eq(expected_result)
    expect(ordered_items).to_not include(unordered_item)
  end






# ========================
# You should be approximately here by the end of Week 4
# ========================






  it '26. returns the names of items that are associated with one or more orders' do
    unordered_item_1 = create(:item, name: 'Unordered Item_1')
    unordered_item_2 = create(:item, name: 'Unordered Item_2')
    unordered_item_3 = create(:item, name: 'Unordered Item_3')

    unordered_items = [unordered_item_1, unordered_item_2, unordered_item_3, @item_6.name]
    expected_result = ['Apples', 'Bananas', 'Carrots', 'Dumplings', 'Eggplant', 'Figs', 'Grapes', 'Ice Cream', 'Jalapeno']

    # ----------------------- Using Ruby -------------------------
    items = Item.all

    ordered_items = items.map do |item|
      item if item.orders.present?
    end.compact

    ordered_items_names = ordered_items.map(&:name)
    ordered_items_names.sort
    # ------------------------------------------------------------

    # ------------------ ActiveRecord Solution ----------------------
    # Solution goes here
    ordered_items_names = Item.joins(:orders).distinct(:order_id).order(:name).pluck(:name)
    # When you find a solution, experiment with adjusting your method chaining
    # Which ones are you able to switch around without relying on Ruby's Enumerable methods?
    # ---------------------------------------------------------------

    # Expectations
    expect(ordered_items_names).to eq(expected_result)
    expect(ordered_items_names).to_not include(unordered_items)
  end

  it '27. returns a table of information for all users orders' do
    custom_results = [@user_3, @user_1, @user_2]

    # using a single ActiveRecord call, fetch a joined object that mimics the
    # following table of information:
    # -------------------------------------------------------------------------
    # user.name  |  total_order_count
    # Ian        |         4
    # Brian      |         5
    # Megan      |         6

    # ------------------ ActiveRecord Solution ----------------------
    custom_results = []

    custom_results = User.joins(items: :order_items)
                         .select("users.name, count(distinct order_items.order_id) as total_order_count")
                         .group(:name)
                         .order("total_order_count asc")

    custom_results = User.joins(:orders)
                         .select("users.name, count(orders.id) as total_order_count")
                         .group(:name)
                        .order("total_order_count asc")
    # ---------------------------------------------------------------

    expect(custom_results[0].name).to eq(@user_3.name)
    expect(custom_results[0].total_order_count).to eq(4)
    expect(custom_results[1].name).to eq(@user_2.name)
    expect(custom_results[1].total_order_count).to eq(5)
    expect(custom_results[2].name).to eq(@user_1.name)
    expect(custom_results[2].total_order_count).to eq(6)
  end

  it '28. returns a table of information for all users items' do
    custom_results = [@user_2, @user_3, @user_1]

    # using a single ActiveRecord call, fetch a joined object that mimics the
    # following table of information:
    # --------------------------------------------------------------------------
    # user.name    |  total_item_count
    # Brian        |         20
    # Ian          |         16
    # Megan        |         24

    # ------------------ ActiveRecord Solution ----------------------
    custom_results = []
    # binding.pry
    custom_results = User.joins(:items)
                         .select("users.name, count(items.id) as total_item_count")
                         .group(:name)
                         .order(:name)
    # ---------------------------------------------------------------

    expect(custom_results[0].name).to eq(@user_2.name)
    expect(custom_results[0].total_item_count).to eq(20)
    expect(custom_results[1].name).to eq(@user_3.name)
    expect(custom_results[1].total_item_count).to eq(16)
    expect(custom_results[2].name).to eq(@user_1.name)
    expect(custom_results[2].total_item_count).to eq(24)
  end

  it '29. returns a table of information for all users orders and item counts' do
    # using a single ActiveRecord call, fetch a joined object that mimics the
    # following table of information:
    # ---------------------------------------
    # user_name  | order_id  | avg_item_cost
    # Megan      | 5         | 50
    # Megan      | 11        | 125
    # Megan      | 8         | 145
    # Megan      | 14        | 150
    # Megan      | 9         | 187
    # Megan      | 6         | 217
    # Ian        | 1         | 125
    # Ian        | 12        | 162
    # Ian        | 15        | 212
    # Ian        | 10        | 250
    # Brian      | 4         | 75
    # Brian      | 3         | 137
    # Brian      | 7         | 175
    # Brian      | 2         | 200
    # Brian      | 13        | 225

    # the raw SQL to produce this table would look like the following:
    # select
    #   users.name as user_name,
    #   orders.id as order_id,
    #   orders.amount / count(order_items.id) as avg_item_cost
    # from users
    #   join orders on orders.user_id=users.id
    #   join order_items on order_items.order_id=orders.id
    # group by users.name, orders.id
    # order by user_name desc, avg_item_cost asc
    #
    # how will you turn this into the proper ActiveRecord commands?

    # ------------------ ActiveRecord Solution ----------------------
    data = []
    data = User.joins(orders: :order_items)
               .group("orders.id")
               .select("users.name as user_name, orders.id as order_id, (orders.amount / count(order_items.order_id)) as avg_item_cost")
               .order("user_name desc, avg_item_cost asc")
    # ---------------------------------------------------------------

    expect([data[0].user_name,data[0].order_id,data[0].avg_item_cost]).to eq([@user_1.name, @order_1.id, 50])
    expect([data[1].user_name,data[1].order_id,data[1].avg_item_cost]).to eq([@user_1.name, @order_4.id, 125])
    expect([data[2].user_name,data[2].order_id,data[2].avg_item_cost]).to eq([@user_1.name, @order_6.id, 145])
    expect([data[3].user_name,data[3].order_id,data[3].avg_item_cost]).to eq([@user_1.name, @order_7.id, 150])
    expect([data[4].user_name,data[4].order_id,data[4].avg_item_cost]).to eq([@user_1.name, @order_10.id, 187])
    expect([data[5].user_name,data[5].order_id,data[5].avg_item_cost]).to eq([@user_1.name, @order_13.id, 217])
    expect([data[6].user_name,data[6].order_id,data[6].avg_item_cost]).to eq([@user_3.name, @order_3.id, 125])
    expect([data[7].user_name,data[7].order_id,data[7].avg_item_cost]).to eq([@user_3.name, @order_9.id, 162])
    expect([data[8].user_name,data[8].order_id,data[8].avg_item_cost]).to eq([@user_3.name, @order_12.id, 212])
    expect([data[9].user_name,data[9].order_id,data[9].avg_item_cost]).to eq([@user_3.name, @order_15.id, 250])
    expect([data[10].user_name,data[10].order_id,data[10].avg_item_cost]).to eq([@user_2.name, @order_2.id, 75])
    expect([data[11].user_name,data[11].order_id,data[11].avg_item_cost]).to eq([@user_2.name, @order_5.id, 137])
    expect([data[12].user_name,data[12].order_id,data[12].avg_item_cost]).to eq([@user_2.name, @order_8.id, 175])
    expect([data[13].user_name,data[13].order_id,data[13].avg_item_cost]).to eq([@user_2.name, @order_11.id, 200])
    expect([data[14].user_name,data[14].order_id,data[14].avg_item_cost]).to eq([@user_2.name, @order_14.id, 225])
  end

  it '30. returns the names of items that have been ordered without n+1 queries' do
    # What is an n+1 query?
    # This video is older, but the concepts explained are still relevant:
    # http://railscasts.com/episodes/372-bullet

    # Don't worry about the lines containing Bullet. This is how we are detecting n+1 queries.
    Bullet.enable = true
    Bullet.raise = true
    Bullet.start_request

    # ------------------------------------------------------
    orders = Order.includes(items: :order_items)# Edit only this line
    # ------------------------------------------------------

    # Do not edit below this line
    orders.each do |order|
      order.items.each do |item|
        item.name
      end
    end

    # Don't worry about the lines containing Bullet. This is how we are detecting n+1 queries.
    Bullet.perform_out_of_channel_notifications
    Bullet.end_request
  end
end
