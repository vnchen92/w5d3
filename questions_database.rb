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

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            users
        WHERE
            id = ?
        SQL

        User.new(user.first)
    end

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ? AND lname = ?
        SQL

        User.new(user.first)
    end


    def initialize(names)
        @id = names['id']
        @fname = names['fname']
        @lname = names['lname']
    end


end

class Question

    def self.find_by_id(id)
        _question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?
        SQL

        Question.new(_question.first)
    end
    
    def initialize(data)
        @id = data['id']
        @title = data['title']
        @body = data['body']
        @user_id = data['user_id']
    end


end

class QuestionFollow

    def self.find_by_id(id)
        follow = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            question_follows
        WHERE
            id = ?
        SQL

        QuestionFollow.new(follow.first)
    end
    
    def initialize(data)
        @id = data['id']
        @user_id = data['user_id']
        @question_id = data['question_id']
    end


end

class Reply

    def self.find_by_id(id)
        _reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            replies
        WHERE
            id = ?
        SQL

        Reply.new(_reply.first)
    end
    
    def initialize(data)
        @id = data['id']
        @user_id = data['user_id']
        @question_id = data['question_id']
        @body = data['body']
        @reply_id = data['reply_id']
    end


end

class  QuestionLike

    def self.find_by_id(id)
        like = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            question_likes
        WHERE
            id = ?
        SQL

        QuestionLike.new(like.first)
    end
    
    def initialize(data)
        @id = data['id']
        @user_id = data['user_id']
        @question_id = data['question_id']
    end


end