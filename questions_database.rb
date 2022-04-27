require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation=true
        self.results_as_hash=true
    end

end

class User


    def initialize(names)
        @id = names['id']
        @fname = names['fname']
        @lname = names['lname']
    end


end

class Question
    
    def initialize(data)
        @id = data['id']
        @title = data['title']
        @body = data['body']
        @user_id = data['user_id']
    end


end