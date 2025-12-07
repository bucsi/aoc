import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/order.{type Order}
import gleam/string

import helpers/unsafe_int

pub type Hand {
  Hand(cards: List(String), bet: Int, kind: Kind, original: String)
}

pub fn parse(input: String) -> List(Hand) {
  input
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> list.map(parse_hand)
}

fn parse_hand(hand: List(String)) -> Hand {
  let assert [cards, bet] = hand

  let sorted_cards = cards |> string.to_graphemes |> list.sort(compare_value)

  Hand(sorted_cards, unsafe_int.parse(bet), Nothing, cards)
}

pub type Kind {
  FiveOfAKind
  FourOfAKind
  FullHouse
  ThreeOfAKind
  TwoPair
  OnePair
  HighCard
  Nothing
}

pub fn pt_1(hands: List(Hand)) {
  hands
  |> list.map(fn(hand) {
    let kind = cards_to_type(hand.cards)
    Hand(..hand, kind: kind)
  })
  |> list.sort(make_compare(compare_value))
  |> list.index_map(fn(hand, i) {
    // io.print(int.to_string(i) <> "   ")
    // io.debug(hand)
    { i + 1 } * hand.bet
  })
  |> int.sum
}

pub fn pt_2(hands: List(Hand)) {
  hands
  |> list.map(fn(hand) {
    let kind = cards_to_type2(hand.cards)
    Hand(..hand, kind: kind)
  })
  |> list.sort(make_compare(compare_value2))
  |> list.index_map(fn(hand, i) {
    io.print("p2  " <> int.to_string(i) <> "   ")
    echo hand
    { i + 1 } * hand.bet
  })
  |> int.sum
}

fn cards_to_type(cards: List(String)) -> Kind {
  case cards {
    [a, b, c, d, e] if a == b && b == c && c == d && d == e -> FiveOfAKind
    [a, b, c, d, _] | [_, a, b, c, d] if a == b && b == c && c == d ->
      FourOfAKind
    [a, b, c, d, e] if a == b && b == c && d == e -> FullHouse
    [a, b, c, d, e] if c == d && d == e && a == b -> FullHouse
    [a, b, c, _, _] | [_, a, b, c, _] | [_, _, a, b, c] if a == b && b == c ->
      ThreeOfAKind
    [a, b, c, d, _] | [a, b, _, c, d] | [_, a, b, c, d] if a == b && c == d ->
      TwoPair
    [a, b, _, _, _] | [_, a, b, _, _] | [_, _, a, b, _] | [_, _, _, a, b]
      if a == b
    -> OnePair
    [a, b, c, d, e] -> is_highcard(a, b, c, d, e)
    _ -> debug_nothing(cards)
  }
}

fn is_highcard(a, b, c, d, e) {
  let are_unique =
    a != b
    && a != c
    && a != d
    && a != e
    && b != c
    && b != d
    && b != e
    && c != d
    && c != e
    && d != e

  case are_unique {
    True -> HighCard
    _ -> debug_nothing([a, b, c, d, e])
  }
}

fn debug_nothing(cards) {
  echo cards

  Nothing
}

fn make_compare(comparator) {
  fn(a, b) { compare(a, b, comparator) }
}

fn compare(a: Hand, b: Hand, comparator) -> Order {
  case a.kind, b.kind {
    x, y if x == y -> comparator(b.original, a.original)
    FiveOfAKind, _ -> order.Gt
    _, FiveOfAKind -> order.Lt
    FourOfAKind, _ -> order.Gt
    _, FourOfAKind -> order.Lt
    FullHouse, _ -> order.Gt
    _, FullHouse -> order.Lt
    ThreeOfAKind, _ -> order.Gt
    _, ThreeOfAKind -> order.Lt
    TwoPair, _ -> order.Gt
    _, TwoPair -> order.Lt
    OnePair, _ -> order.Gt
    _, OnePair -> order.Lt
    HighCard, _ -> order.Gt
    _, HighCard -> order.Lt
    Nothing, Nothing -> order.Eq
  }
}

fn compare_value(a: String, b: String) -> Order {
  use <- bool.guard(a == "" && b == "", order.Eq)

  let assert Ok(#(a_first, a_rest)) = string.pop_grapheme(a)
  let assert Ok(#(b_first, b_rest)) = string.pop_grapheme(b)
  case a_first, b_first {
    x, y if x == y -> compare_value(a_rest, b_rest)
    "A", _ -> order.Lt
    _, "A" -> order.Gt
    "K", _ -> order.Lt
    _, "K" -> order.Gt
    "Q", _ -> order.Lt
    _, "Q" -> order.Gt
    "J", _ -> order.Lt
    _, "J" -> order.Gt
    "T", _ -> order.Lt
    _, "T" -> order.Gt
    _, _ -> int.compare(unsafe_int.parse(b_first), unsafe_int.parse(a_first))
  }
}

fn two_cards_three_jokers(cards: List(String)) -> Kind {
  case cards {
    [a, b] if a == b -> FiveOfAKind
    [a, b] if a != b -> FourOfAKind
    _ -> panic as "two_cards_three_jokers error"
  }
}

fn three_cards_two_jokers(cards: List(String)) -> Kind {
  case cards {
    [a, b, c] if a == b && b == c -> FiveOfAKind
    [a, b, _] | [_, a, b] if a == b -> FourOfAKind
    [a, b, c] if a != b && b != c && a != c -> ThreeOfAKind
    _ -> panic as "three_cards_two_jokers error"
  }
}

fn four_cards_one_joker(cards: List(String)) -> Kind {
  case cards {
    [a, b, c, d] if a == b && b == c && c == d -> FiveOfAKind
    [a, b, c, _] | [_, a, b, c] if a == b && b == c -> FourOfAKind
    [a, b, c, d] if a == b || b == c || c == d -> ThreeOfAKind
    [a, b, c, d] if a != b && b != c && c != d -> TwoPair
    _ -> panic as "four_cards_one_joker error"
  }
}

fn handle(cards: List(String), function) -> Kind {
  cards |> list.filter(fn(c) { c != "J" }) |> function
}

fn cards_to_type2(cards: List(String)) -> Kind {
  case list.count(cards, fn(c) { c == "J" }) {
    4 -> FiveOfAKind
    3 -> handle(cards, two_cards_three_jokers)
    2 -> handle(cards, three_cards_two_jokers)
    1 -> handle(cards, four_cards_one_joker)
    _ ->
      case cards {
        [a, b, c, d, e] if a == b && b == c && c == d && d == e -> FiveOfAKind

        [a, b, c, d, _] | [_, a, b, c, d] if a == b && b == c && c == d ->
          FourOfAKind
        [a, b, c, d, e] if a == b && b == c && d == e -> FullHouse
        [a, b, c, d, e] if c == d && d == e && a == b -> FullHouse
        [a, b, c, _, _] | [_, a, b, c, _] | [_, _, a, b, c] if a == b && b == c ->
          ThreeOfAKind
        [a, b, c, d, _] | [a, b, _, c, d] | [_, a, b, c, d] if a == b && c == d ->
          TwoPair
        [a, b, _, _, _] | [_, a, b, _, _] | [_, _, a, b, _] | [_, _, _, a, b]
          if a == b
        -> OnePair
        [a, b, c, d, e] -> is_highcard(a, b, c, d, e)
        _ -> debug_nothing(cards)
      }
  }
}

fn compare_value2(a: String, b: String) -> Order {
  use <- bool.guard(a == "" && b == "", order.Eq)

  let assert Ok(#(a_first, a_rest)) = string.pop_grapheme(a)
  let assert Ok(#(b_first, b_rest)) = string.pop_grapheme(b)
  case a_first, b_first {
    x, y if x == y -> compare_value(a_rest, b_rest)
    "J", _ -> greater_than(a, b)
    _, "J" -> less_than(a, b)
    // ^^^ purposefully switched, as J is the lowest now
    "A", _ -> order.Lt
    _, "A" -> order.Gt
    "K", _ -> order.Lt
    _, "K" -> order.Gt
    "Q", _ -> order.Lt
    _, "Q" -> order.Gt
    "T", _ -> order.Lt
    _, "T" -> order.Gt
    _, _ -> int.compare(unsafe_int.parse(b_first), unsafe_int.parse(a_first))
  }
}

fn less_than(a, b) -> Order {
  io.println("     " <> a <> " is greater than " <> b)

  order.Lt
}

fn greater_than(a, b) -> Order {
  io.println("     " <> a <> " is less than " <> b)

  order.Gt
}
