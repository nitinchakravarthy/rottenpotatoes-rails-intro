class Movie < ActiveRecord::Base
    
    def Movie.with_ratings(ratings)
        puts("inside movie model")
        puts(ratings)
        if ratings.length > 0
            where(rating: ratings.keys)
        else
            all
        end
    end
end
