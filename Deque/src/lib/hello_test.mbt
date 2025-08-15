///|
test "@hello.Deque::new/default_capacity" {
  let deque : Deque[Int] = @lib.Deque::new()
  inspect(deque.capacity(), content="16")
  inspect(deque.length(), content="0")
  inspect(deque.is_empty(), content="true")
}

///|
test "@hello.Deque::new/custom_capacity" {
  let deque : Deque[Int] = @lib.Deque::new(initial_capacity=32)
  inspect(deque.capacity(), content="32")
  inspect(deque.length(), content="0")
  inspect(deque.is_empty(), content="true")
}

///|
test "panic @hello.Deque::new/negative_capacity" {
  let _ : Deque[Int] = @lib.Deque::new(initial_capacity=-1)

}

///|
test "panic Deque::remove/invalid_index" {
  let deque = Deque::new(initial_capacity=4)
  deque.push_back(1)
  deque.push_front(3)
  inspect(deque.remove(-1), content="None")
  inspect(deque.remove(2), content="None")
  inspect(deque.length(), content="2")
}

///|
test "empty deque" {
  let d : Deque[Int] = @lib.Deque::new(initial_capacity=2)
  inspect(d.is_empty(), content="true")
  inspect(d.front(), content="None")
  inspect(d.back(), content="None")
  inspect(d.pop_front(), content="None")
  inspect(d.pop_back(), content="None")
}
