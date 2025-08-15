// 实现一个双端队列,说明队列这个类的内置变量有哪些,类的函数有什么

/// A double-ended queue implementation
pub struct Deque[T] {
  mut data: Array[T]  // Internal array to store elements
  mut front: Int      // Index of the front element
  mut back: Int       // Index of the back element
  mut size: Int       // Current number of elements
  mut capacity: Int   // Total capacity of the queue
}

/// Create a new Deque with initial capacity
///|
pub fn[T] Deque::new(initial_capacity~ : Int = 16) -> Deque[T] {
  {
    data: Array::new(capacity=initial_capacity),
    front: 0,
    back: 0,
    size: 0,
    capacity: initial_capacity,
  }
}

/// Check if the deque is empty
pub fn[T] Deque::is_empty(self: Deque[T]) -> Bool {
  self.size == 0
}

/// Get the current size of the deque
pub fn[T] Deque::length(self: Deque[T]) -> Int {
  self.size
}

/// Get the current capacity of the deque
pub fn[T] Deque::capacity(self: Deque[T]) -> Int {
  self.capacity
}

/// Add an element to the front of the deque
pub fn[T] Deque::push_front(self: Deque[T], value: T) -> Unit {
  if self.size == self.capacity {
    self.grow()
  }
  self.front = (self.front - 1 + self.capacity) % self.capacity
  self.data[self.front] = value
  self.size = self.size + 1
}

/// Add an element to the back of the deque
pub fn[T] Deque::push_back(self: Deque[T], value: T) -> Unit {
  if self.size == self.capacity {
    self.grow()
  }
  self.data[self.back] = value
  self.back = (self.back + 1) % self.capacity
  self.size = self.size + 1
}

/// Remove and return the front element
pub fn[T] Deque::pop_front(self: Deque[T]) -> T? {
  if self.is_empty() {
    None
  } else {
    let value = self.data[self.front]
    self.front = (self.front + 1) % self.capacity
    self.size = self.size - 1
    Some(value)
  }
}

/// Remove and return the back element
pub fn[T] Deque::pop_back(self: Deque[T]) -> T? {
  if self.is_empty() {
    None
  } else {
    self.back = (self.back - 1 + self.capacity) % self.capacity
    let value = self.data[self.back]
    self.size = self.size - 1
    Some(value)
  }
}

/// Get the front element without removing it
pub fn[T] Deque::front(self: Deque[T]) -> T? {
  if self.is_empty() {
    None
  } else {
    Some(self.data[self.front])
  }
}

/// Get the back element without removing it
pub fn[T] Deque::back(self: Deque[T]) -> T? {
  if self.is_empty() {
    None
  } else {
    let index = (self.back - 1 + self.capacity) % self.capacity
    Some(self.data[index])
  }
}

/// Internal function to grow the capacity when full
///|
fn[T] Deque::grow(self : Deque[T]) -> Unit {
  let new_capacity = self.capacity * 2
  let new_data = Array::new(capacity=new_capacity)

  // Copy elements to new array in order
  let mut i = 0
  while i < self.size {
    let index = (self.front + i) % self.capacity
    new_data[i] = self.data[index]
    i = i + 1
  }
  self.data = new_data
  self.front = 0
  self.back = self.size
  self.capacity = new_capacity
}
/// Clear all elements from the deque
pub fn[T] Deque::clear(self: Deque[T]) -> Unit {
  self.front = 0
  self.back = 0
  self.size = 0
}
/// Get element at index
pub fn[T] Deque::get(self: Deque[T], index: Int) -> T? {
  if index < 0 || index >= self.size {
    None
  } else {
    let actual_index = (self.front + index) % self.capacity
    Some(self.data[actual_index])
  }
}
/// Set element at index
pub fn[T] Deque::set(self: Deque[T], index: Int, value: T) -> Bool {
  if index < 0 || index >= self.size {
    false
  } else {
    let actual_index = (self.front + index) % self.capacity
    self.data[actual_index] = value
    true
  }
}
/// Convert deque to array

/// Iterate through all elements
pub fn[T] Deque::each(self: Deque[T], f: (T) -> Unit) -> Unit {
  let mut i = 0
  while i < self.size {
    let index = (self.front + i) % self.capacity
    f(self.data[index])
    i = i + 1
  }
}
/// Iterate with index through all elements
pub fn[T] Deque::eachi(self: Deque[T], f: (Int, T) -> Unit) -> Unit {
  let mut i = 0
  while i < self.size {
    let index = (self.front + i) % self.capacity
    f(i, self.data[index])
    i = i + 1
  }
}

pub fn[T] Deque::iter(self: Deque[T]) -> Iter[T] {
  Iter::new(fn(f: (T) -> IterResult) -> IterResult {
    let mut i = 0
    while i < self.size {
      let index = (self.front + i) % self.capacity
      match f(self.data[index]) {
        IterEnd => { return IterEnd }
        IterContinue => { i = i + 1 }
      }
    }
    IterEnd
  })
}
/// Reverse the deque in-place
pub fn[T] Deque::reverse(self: Deque[T]) -> Unit {
  let mut start = 0
  let mut end = self.size - 1
  
  while start < end {
    let start_idx = (self.front + start) % self.capacity
    let end_idx = (self.front + end) % self.capacity
    let temp = self.data[start_idx]
    self.data[start_idx] = self.data[end_idx]
    self.data[end_idx] = temp
    start = start + 1
    end = end - 1
  }
}

/// Remove element at index
pub fn[T] Deque::remove(self: Deque[T], index: Int) -> T? {
  if index < 0 || index >= self.size {
    None
  } else {
    let actual_index = (self.front + index) % self.capacity
    let value = self.data[actual_index]
    
    // Shift elements to fill the gap
    let mut i = index
    while i < self.size - 1 {
      let curr = (self.front + i) % self.capacity
      let next = (self.front + i + 1) % self.capacity
      self.data[curr] = self.data[next]
      i = i + 1
    }
    
    self.size = self.size - 1
    self.back = (self.back - 1 + self.capacity) % self.capacity
    Some(value)
  }
}