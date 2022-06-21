:- dynamic tree_y/2.
:- dynamic tree_n/2.
:- dynamic guess_y/2.
:- dynamic guess_n/2.

try_guessing(Tree, Guess) :-
    write(Tree), write(" (yes./no.) "),      % Prints question and possible answers
    nl, read(Input), nl,        % Read input
    (
    (Input=yes, tree_y(Tree, NewTree), try_guessing(NewTree, Guess), !);
    (Input=yes, not(tree_y(Tree, _)), guess_y(Tree, Guess), !);
    (Input=no, tree_n(Tree, NewTree), try_guessing(NewTree, Guess), !);
    (Input=no, not(tree_n(Tree, _)), guess_n(Tree, Guess), !)
        ).
    
check_guess(Guess, Input) :-
    write("Your animal is "),
    write(Guess), write(" (yes./no.) "),      % Guess the animal and player must confirm if it is right or wrong
    nl, read(Input), nl,        % Read input
    (
      (Input=yes, write("I knew it!"), nl);  
      (Input=no, write("Oh no! I guessed wrong"), nl)  
        ).

update_animals(Guess) :-
    write("Which animal did you think of? "),
    nl, read(PlayerAnimal),     % Read player animal

    write("What question should I make to guess your animal?"),
    nl, read(NewQuestion),

    write("What is the answer to that question according to your animal? "),
    nl, write(NewQuestion), write(" (yes./no.) "),
    nl, read(Answer),

    (
        (
            guess_y(OldTree, Guess),                    % Changes guess to a tree, so we can have a new question
            retract(guess_y(OldTree, Guess)),           % Remove guess
            assertz(tree_y(OldTree, NewQuestion))       % Create tree
            );
        
        (
            guess_n(OldTree, Guess),                    % Changes guess to a tree, so we can have a new question
            retract(guess_n(OldTree, Guess)),           % Remove guess
            assertz(tree_n(OldTree, NewQuestion))       % Create tree
            )
        ),
    (
        (
            Answer=yes,
            assertz(guess_y(NewQuestion,PlayerAnimal)),
            assertz(guess_n(NewQuestion, Guess))
            );
        (
            Answer=no,
            assertz(guess_n(NewQuestion,PlayerAnimal)),
            assertz(guess_y(NewQuestion, Guess))
            )
        ).



update :-
    tell('animals.txt'),
    listing(start_pos),
    listing(tree_y),
    listing(tree_n),
    listing(guess_y),
    listing(guess_n),
    told.

play :-
    consult('animals.txt'),
    write("Hi! I'm a computer intelligence made to guess the animal you are thinking."),
    nl, write("Think about any animal and don't tell me!"),
    nl, write("Answer my questions with yes or no, and don't forget to add a . at the end of every answer"),
    nl, nl, nl,
    start_pos(FirstQuestion), try_guessing(FirstQuestion, Answer), check_guess(Answer, GameOver),
    (
        (GameOver=yes, write("I told you I would guess your animal!"), nl);
        (GameOver=no, update_animals(Answer), write("I will guess it next time!"), nl)
    ),
    update,
    write("Do you want to play again?"), 
    nl, read(Restart),
    (   
        (Restart=yes, nl, play, !, fail);
        (Restart=no, write("Thanks for playing!"), nl, !, fail)
    ).