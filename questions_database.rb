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
    attr_accessor :fname, :lname

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

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end
end

class Question
    attr_accessor :title, :body

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
    
    def self.find_by_author_id(user_id)
        _question = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
            *
        FROM
            questions
        WHERE
            user_id = ?
        SQL
        
        _question.map{|q|Question.new(q)}
    end
    
    def initialize(data)
        @id = data['id']
        @title = data['title']
        @body = data['body']
        @user_id = data['user_id']
    end

    def auther
        @user_id
    end

    def replies
        Reply.find_by_question_id(@id)
    end

end

class QuestionFollow
    attr_accessor :user_id, :question_id

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
    ##################################################################################
    def self.followers_for_question_id(question_id)
        followers = QuestionsDatabase.instance.execute(<<-SQL, @question_id)
        SELECT
             *
        FROM
            users
        JOIN
            question_follows ON question_follows.user_id = users.id
        WHERE
            question_id = ?

        
        SQL

        followers.map{|q|QuestionFollow.new(q)}
    end
    ##################################################################################

    def initialize(data)
        @id = data['id']
        @user_id = data['user_id']
        @question_id = data['question_id']
    end


end

class Reply
    attr_accessor :user_id, :question_id, :body, :reply_id
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
    
    def self.find_by_user_id(user_id)
        _reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
            *
        FROM
            replies
        WHERE
            user_id = ?
        SQL

        _reply.map{|q|Reply.new(q)}
    end
    
    def self.find_by_question_id(question_id)
        _reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?
        SQL

        _reply.map{|q|Reply.new(q)}
    end
    
    def initialize(data)
        @id = data['id']
        @user_id = data['user_id']
        @question_id = data['question_id']
        @body = data['body']
        @reply_id = data['reply_id']
    end

    def auther
        @user_id
    end

    def question
        @question_id
    end

    def parent_reply
        @reply_id
    end

    def child_replies
        QuestionsDatabase.instance.execute(<<-SQL, @body)
        SELECT * FROM replies WHERE body = ?
        SQL
    end
end

class  QuestionLike
    attr_accessor :user_id, :question_id
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
