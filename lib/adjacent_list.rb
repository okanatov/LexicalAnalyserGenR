class AdjacentList
  attr_accessor :start, :end

  def initialize
    @vertices = []
  end

  def add_edge(x, y, label)
    if @vertices[x].nil?
      @vertices[x] = []
      @vertices[x][0] = { label => y }
    else
      last = @vertices[x].length
      @vertices[x][last] = { label => y }
    end
  end

  def +(other)
    start_idx = last + 1
    other.vertices.each_index do |i|
      next if other.vertices[i].nil?
      other.vertices[i].select! do |e|
        e.each_key { |k| e[k] = e[k] + start_idx }
      end
      @vertices[start_idx + i] = other.vertices[i]
    end
    @vertices
  end

  def labels(x)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect { |e| e.keys.first }
    end
  end

  def neigbours(x)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect { |e| e.values.first }
    end
  end

  def neigbour(x, label)
    if @vertices[x].nil?
      return []
    else
      neigbours = @vertices[x].select { |e| e.key?(label) }
      neigbours.collect { |e| e.values.first }
    end
  end

  def set_neigbour(x, label, y)
    if @vertices[x].nil?
      return []
    else
      @vertices[x].collect! do |e|
        e[label] = y if e.key?(label)
        e
      end
    end
  end

  def dfs
    @path = []
    dfs_visit(@start)
    @path
  end

  def last
    all_vertices = (0..@vertices.length).collect { |e| neigbours(e) }
    if all_vertices.flatten!.empty?
      return -1
    else
      all_vertices.sort!.last
    end
  end

  def to_s
    @vertices.to_s
  end

  protected

  attr_reader :vertices

  private

  def dfs_visit(vertix)
    @found = true if vertix == @end
    return if @vertices[vertix].nil? || @found

    labels(vertix).each do |e|
      @path << e

      neigbours = neigbour(vertix, e)
      neigbours.each { |n| dfs_visit(n) }

      break if @found
      @path.pop
    end
  end

  def final?(vertix)
    final_states = (0..last).select { |e| @vertices.at(e).nil? }
    final_states.include?(vertix)
  end
end
