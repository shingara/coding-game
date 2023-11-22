STDOUT.sync = true # DO NOT REMOVE
# Complete the hackathon before your opponent by following the principles of Green IT

class Applications
  def initialize
    @previous_applications = {}
    @applications = {}
  end

  def update(application)
    @previous_applications[application.id] = @applications[application.id]
    @applications[application.id] = application
  end

  def values
    @applications.values
  end

  def new_round
    @previous_applications = {}
  end

  def clean_done
    @applications.delete_if{|k,v| !@previous_applications.keys.include?(k) }
  end
end

class Application
    # training_needed: number of TRAINING skills needed to release this application
    # coding_needed: number of CODING skills needed to release this application
    # daily_routine_needed: number of DAILY_ROUTINE skills needed to release this application
    # task_prioritization_needed: number of TASK_PRIORITIZATION skills needed to release this application
    # architecture_study_needed: number of ARCHITECTURE_STUDY skills needed to release this application
    # continuous_delivery_needed: number of CONTINUOUS_DELIVERY skills needed to release this application
    # code_review_needed: number of CODE_REVIEW skills needed to release this application
    # refactoring_needed: number of REFACTORING skills needed to release this application
  def initialize(options=[])
    @object_type=options[0]
    @id = options[1].to_i
    @needs = {
      training: options[2].to_i,
      coding: options[3].to_i,
      daily_routine: options[4].to_i,
      task_prioritization: options[5].to_i,
      architecture_study: options[6].to_i,
      continous_delivery: options[7].to_i,
      code_review: options[8].to_i,
      refactoring: options[9].to_i
    }
  end
  attr_reader :id

  def card_needed
    @needs.select{ |k,v| v > 0 }
  end

  def card_remain_by_player(hand)
    card_remain = {}
    card_needed.each do |k,v|
      # debug "#{k} => #{v} / #{hand.cards[k]}"
      # debug hand.cards.inspect
      card_remain[k] = v - (hand.cards[k]*2)
    end
    card_remain
  end

  def dept_generate(hand)
    card_missing = card_needed.dup
    debug("application : #{self.id} => #{card_missing.inspect}")
    hand_remain = hand.cards.dup
    card_missing.each do |k, v|
      comp_available = hand_remain[k] || 0
      card_use = (comp_available*2) % v
      debug("card use : card_user #{k} / #{v} card_missing => #{card_missing[k]}")
      hand_remain[k] = hand_remain[k] - (card_use*2)
      card_missing[k] = card_missing[k] - card_use
      debug("end card use : calc #{card_missing[k] - card_use} #{k} / #{v} card_missing => #{card_missing[k]}")
    end
    debug("end application : #{self.id} => #{card_missing.inspect}")
    card_missing.values.sum - hand.cards[:bonus]
  end

end

class Player
  def initialize(options)
    @player_location = options[0]
    @player_score = options[1]
    @player_permanent_daily_routine_cards = options[2]
    @player_permanent_architecture_study_cards = options[3]
  end
  attr_reader :player_location
end

class Decks
  def initialize
    @hand = nil
    @draw = nil
    @discard = nil
  end

  def add(card_location)
    @hand = card_location if card_location.hand?
    @draw = card_location if card_location.draw?
    @discard = card_location if card_location.discard?
  end
  attr_reader :hand

end

class CardLocation
  def initialize(options)
    @cards_location = options[0]
    @cards = {
      training: options[1].to_i,
      coding: options[2].to_i,
      daily_routine: options[3].to_i,
      task_prioritization: options[4].to_i,
      architecture_study: options[5].to_i,
      continous_delivery: options[6].to_i,
      code_review: options[7].to_i,
      refactoring: options[8].to_i,
      bonus: options[9].to_i,
      technical_debt: options[10].to_i
    }
  end
  attr_reader :cards

  def hand?
    @cards_location == 'HAND'
  end
  def draw?
    @cards_location == 'DRAW'
  end
  def discard?
    @cards_location == 'DISCARD'
  end
end

class SearchCard
  def self.zone
    {
      training: 0,
      coding: 1,
      daily_routine: 2,
      task_prioritization: 3,
      architecture_study: 4,
      continous_delivery: 5,
      code_review: 6,
      refactoring: 7
    }
  end
  def self.zone_id_card_missing(applications, hand, except_zone)
    remain_card = ApplicationDone.check_applications(applications, hand)
    remain_card.pick_less_missing do |card|
      debug "card : #{card}"
      if zone[card] != except_zone
        debug "zone :#{zone[card]}"
        return zone[card]
      end
    end
  end
end

class SearchApplication
  def self.id_finish(applications, hand)
    remain_card = ApplicationDone.check_applications(applications, hand)
    remain_card.finish_application.first
  end
end

class RemainCard
  def initialize
    @remain = {}
    @finish_application = []
  end
  attr_reader :finish_application

  def add(application, card_remain)
    nb_card = card_remain.values.sum
    @remain[application.id] = {
      cards: card_remain,
      nb_card: nb_card
    }
    #debug "application : #{application.id}, nb_card : #{nb_card}, card_remain: #{card_remain.inspect}"
    if nb_card == 0
      @finish_application << application.id
    end
  end

  def pick_less_missing
    @remain.sort_by{|k,v|
      v[:nb_card]
    }.each do |k, v|
      v[:cards].select{|k,v| v > 0 }.each do |card, _nb|
        yield card
      end
    end
  end
end

class ApplicationDone
  def self.check_applications(applications, hand)
    remain_card = RemainCard.new
    applications.values.each do |application|
      remain_card.add(
        application,
        application.card_remain_by_player(hand)
      )
    end
    remain_card
  end

  def self.less_depth(applications, hand)
    applications.values.map do |application|
      [application.id, application.dept_generate(hand)]
    end
  end
end

def debug(str)
  STDERR.puts str
end


applications = Applications.new
# game loop
loop do
  players = []

  game_phase = gets.chomp # can be MOVE, GIVE_CARD, THROW_CARD, PLAY_CARD or RELEASE
  applications_count = gets.to_i
  applications.new_round

  applications_count.times do
    applications.update(Application.new(gets.split(" ")))
  end
  applications.clean_done

  2.times do
    # player_location: id of the zone in which the player is located
    # player_permanent_daily_routine_cards: number of DAILY_ROUTINE the player has played. It allows them to take cards from the adjacent zones
    # player_permanent_architecture_study_cards: number of ARCHITECTURE_STUDY the player has played. It allows them to draw more cards
    players << Player.new(gets.split(" ").collect { |x| x.to_i })
  end
  decks = Decks.new
  card_locations_count = gets.to_i
  card_locations_count.times do
    # cards_location: the location of the card list. It can be HAND, DRAW, DISCARD or OPPONENT_CARDS (AUTOMATED and OPPONENT_AUTOMATED will appear in later leagues)
    decks.add CardLocation.new(gets.split(" "))
  end
  possible_moves_count = gets.to_i
  possible_moves_count.times do
    possible_move = gets.chomp
    #debug possible_move.inspect
  end
  #debug decks.inspect

  if game_phase == 'MOVE'
    puts "MOVE #{SearchCard.zone_id_card_missing(applications, decks.hand, players[0].player_location)}"
  elsif game_phase == 'RELEASE'
    id_finish = SearchApplication.id_finish(applications, decks.hand)
    debug "less depth : #{ApplicationDone.less_depth(applications, decks.hand).inspect}"

    if id_finish
      puts "RELEASE #{id_finish}"
    else
      puts "WAIT"
    end
  else
    puts "RANDOM"
  end

  # Write an action using puts
  # To debug: STDERR.puts "Debug messages..."


  # In the first league: RANDOM | MOVE <zoneId> | RELEASE <applicationId> | WAIT; In later leagues: | GIVE <cardType> | THROW <cardType> | TRAINING | CODING | DAILY_ROUTINE | TASK_PRIORITIZATION <cardTypeToThrow> <cardTypeToTake> | ARCHITECTURE_STUDY | CONTINUOUS_DELIVERY <cardTypeToAutomate> | CODE_REVIEW | REFACTORING;
  #puts "RANDOM"
end
