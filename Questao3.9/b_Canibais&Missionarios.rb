# 3.9 b) Implemente e resolva o problema de forma ótima, utilizando um algoritmo de busca apropriado.
# Adapter: Lauany Reis da Silva

require 'matrix'
require 'set'

State = Vector

class Node
    @@goal = State[0,0,0]
    @@start = State[3,3,1]
    @@allowed_moves = [
        State[1,0,1],
        State[2,0,1],
        State[0,1,1],
        State[0,2,1],
        State[1,1,1]
    ]

    attr_accessor :state, :parent, :to_goal

    def initialize(state = @@start, parent = nil, to_goal = true)
        @state = state
        @parent = parent
        @to_goal = to_goal
    end

    def to_s
        @state.to_s
    end

    def ==(comp)
        if comp.nil? then false end
        @state == comp.state
    end

    def eql?(comp)
        @state == comp.state
    end

    def hash
        @state.hash
    end

    def goal?
        return @state == @@goal
    end

    def valid?
        m,c = @state.to_a[0,2]
        (m >=0 and c >= 0 and 3-m >= 0 and 3-c >=0) \
        and (m == 0 or m >= c) \
        and (3-m == 0 or 3-m >= 3-c)
    end

    def transition(move)
        Node.new(@to_goal ? @state - move : @state + move, self, !@to_goal)
    end

    def children
        @@allowed_moves.map{|move| transition(move)}.select{|node| node.valid?}
    end

    def find_goal
        examined = Set[]
        queue = *children
        while not queue.empty?
            node = queue.shift
            if examined.add?(node) == nil then next end
            if node.goal? then return node end
            queue.push(*node.children)
        end
    end

end

def tests
    fail unless Node.new(State[3,3,1]).valid?
    fail unless Node.new(State[2,2,0]).valid?
    fail unless Node.new(State[3,1,0]).valid?
    fail if Node.new(State[1,2,1]).valid?
    fail if Node.new(State[2,1,0]).valid?
    fail if Node.new(State[-1,2,1]).valid?
    fail if Node.new(State[2,-1,0]).valid?
    fail if Node.new(State[0,1,1]).goal?
    fail unless Node.new(State[0,0,0]).goal?
    fail unless Node.new(State[3,3,1]).transition(State[1,1,1]).state == State[2,2,0]
    fail if Node.new(State[3,3,1]).transition(State[1,1,1]).state == State[2,2,1]
    fail unless Node.new(State[3,3,1]).children ==
        [Node.new(Vector[3,2,0]), Node.new(Vector[3,1,0]), Node.new(Vector[2,2,0])]
    fail unless Node.new().find_goal.state == State[0,0,0]
end
tests

def run
    nodes = []
    goal = Node.new().find_goal
    while not goal.nil?
        nodes.unshift(goal)
        goal = goal.parent
    end

    # zip nodes com nodes + 1, pegue o diff que nos dá o movimento, então zip move com nodes
    nodes[0..-1].zip(
        nodes[0..-2].zip(nodes[1..-1]).map{ |parent,child| parent.state-child.state }
        ).each do |node, move|
            if node.nil? or move.nil? then break end
            s = node.state
            m = move
            ra = s[2]
            la = ra == 0 ? 1 : 0
            puts "L: "+"M "*s[0]+"C "*s[1] + " " + # o lado sem score
                 "<"*la + "--["+"M"*m[0].abs + "C"*m[1].abs + "]--" + ">"*ra + " " + # o barco
                 "R: "+"M"*(3-s[0]) + "C"*(3-s[1]) # o lado com score
        end
end
puts "/****************************************/"
puts "Legendas:" 
puts "'L': Left (lado esquerdo do rio);"
puts "'R': Rigth (lado direito do rio);"
puts "'M' = Missionário; 'C' = Canibal;" 
puts "'<-- ['M'|'C'] --' = barco;" 
puts "onde '<--' ou '-->' é direção do barco."
puts "/****************************************/"
puts " "
run

=begin
Principais dificuldades (pesquisas da linguagem):
    - sobrescrevendo operadores integrados eql / hash / == e fazendo com que nenhum teste funcione;
    - diferença entre variáveis de classe e instância;
    - getters e setters;
    - tratar matrizes como filas e pilhas;
    - Compreensions / map | collect | select (um pouco como LINQ que é bom);
    - sobrescrevendo to_s (deve ser avaliado como uma string, não apenas um objeto) ie. to_s não é implicitamente chamado;
    - quando usar () e quando usar {} {blocos?};
    - não posso dar valor absoluto um vetor.
=end
