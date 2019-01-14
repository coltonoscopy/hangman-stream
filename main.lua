--[[
    Hangman

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

LOWERCASE_A_ASCII = 97
LOWERCASE_Z_ASCII = 122

HEAD_CENTER_Y = 100
HEAD_SIZE = 64
BODY_LENGTH = 200

local largeFont
local guessesWrong = 0

local ALPHABET = 'abcdefghijklmnopqrstuvwxyz'

local UNGUESSED = 1
local GUESSED_RIGHT = 2
local GUESSED_WRONG = 3

local words = {
    'adventure',
    'bombardment',
    'catastrophe',
    'detrimental',
    'elephant',
    'fox',
    'gregarious',
    'heliography',
    'immediately',
    'jellybean',
    'kleptomaniac',
    'lemonade',
    'microscopic',
    'neurobiology',
    'ophthalmology',
    'procrastination',
    'quintessential',
    'ragnarok',
    'stupendous',
    'telepathy',
    'unanimous',
    'victorious',
    'warmongering',
    'xenophobia',
    'yesterday',
    'zeitgeist'
}
local word
local lettersGuessed = {}
local gameOver
local gameWon

function initGame()
    
    -- iterate over alphabet, setting each letter as unguessed for word
    for i = 1, #ALPHABET do
        local c = ALPHABET:sub(i, i)
        lettersGuessed[c] = UNGUESSED
    end

    guessesWrong = 0
    word = words[math.random(#words)]
    gameOver = false
    gameWon = false
end

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Hangman')

    largeFont = love.graphics.newFont(32)
    hugeFont = love.graphics.newFont(128)
    love.graphics.setFont(largeFont)

    math.randomseed(os.time())
    initGame()
end

function love.update(dt)

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if not gameOver and not gameWon then
        for i = 1, #ALPHABET do
            local c = ALPHABET:sub(i, i)

            if key == c then
                if lettersGuessed[c] == UNGUESSED then
                    local letterInWord = false

                    for j = 1, #word do
                        local wordChar = word:sub(j, j)
                        
                        if c == wordChar then
                            letterInWord = true
                        end
                    end

                    if letterInWord then
                        lettersGuessed[c] = GUESSED_RIGHT
                        local won = true

                        for j = 1, #word do
                            local wordChar = word:sub(j, j)

                            if lettersGuessed[wordChar] ~= GUESSED_RIGHT then
                                won = false
                            end
                        end

                        if won then
                            gameWon = true
                        end
                    else
                        lettersGuessed[c] = GUESSED_WRONG
                        guessesWrong = guessesWrong + 1

                        if guessesWrong == 6 then
                            gameOver = true
                        end
                    end
                end
            end
        end
    else
        if key == 'space' then
            initGame()
        end
    end
end

function love.draw()
    drawAlphabet()
    drawStickFigure()
    drawWord()

    if gameOver or gameWon then
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle('fill', 64, 64, WINDOW_WIDTH - 128, WINDOW_HEIGHT - 128)
        love.graphics.setFont(hugeFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(gameWon and 'GAME WON' or 'GAME OVER', 
            0, WINDOW_HEIGHT / 2 - 64, WINDOW_WIDTH, 'center')
        love.graphics.setFont(largeFont)
        love.graphics.printf('Press Space to Restart', 0, WINDOW_HEIGHT / 2 + 64, WINDOW_WIDTH, 'center')
    end
end

function drawStickFigure()
    
    -- draw head
    if guessesWrong >= 1 then
        love.graphics.circle('line', WINDOW_WIDTH / 2, HEAD_CENTER_Y, HEAD_SIZE)
    end

    -- draw body
    if guessesWrong >= 2 then
        love.graphics.line(WINDOW_WIDTH / 2, HEAD_CENTER_Y + HEAD_SIZE, 
            WINDOW_WIDTH / 2, HEAD_CENTER_Y + HEAD_SIZE + BODY_LENGTH)
    end

    -- draw right arm
    if guessesWrong >= 3 then
        love.graphics.line(WINDOW_WIDTH / 2, HEAD_CENTER_Y + HEAD_SIZE + BODY_LENGTH / 4, 
            WINDOW_WIDTH / 2 + HEAD_SIZE * 2, HEAD_CENTER_Y + HEAD_SIZE - BODY_LENGTH / 4 - HEAD_SIZE)
    end

    -- draw left arm
    if guessesWrong >= 4 then
        love.graphics.line(WINDOW_WIDTH / 2, HEAD_CENTER_Y + HEAD_SIZE + BODY_LENGTH / 4, 
            WINDOW_WIDTH / 2 - HEAD_SIZE * 2, HEAD_CENTER_Y + HEAD_SIZE - BODY_LENGTH / 4 - HEAD_SIZE)
    end

    -- draw right leg
    if guessesWrong >= 5 then
        love.graphics.line(WINDOW_WIDTH / 2, HEAD_CENTER_Y + HEAD_SIZE + BODY_LENGTH, 
            WINDOW_WIDTH / 2 + HEAD_SIZE * 2, HEAD_CENTER_Y + HEAD_SIZE + BODY_LENGTH + HEAD_SIZE)
    end

    -- draw left leg
    if guessesWrong >= 6 then
        love.graphics.line(WINDOW_WIDTH / 2, HEAD_CENTER_Y + HEAD_SIZE + BODY_LENGTH, 
            WINDOW_WIDTH / 2 - HEAD_SIZE * 2, HEAD_CENTER_Y + HEAD_SIZE + BODY_LENGTH + HEAD_SIZE)
    end
end

function drawWord()
    local x = WINDOW_WIDTH / 2 - 180
    local y = WINDOW_HEIGHT / 2 + 120

    for i = 1, #word do
        local c = word:sub(i, i)

        if lettersGuessed[c] ~= GUESSED_RIGHT then
            c = '_'
        end

        love.graphics.print(c, x, y)
        x = x + 32
    end
end

function drawAlphabet()
    local x = 190

    for i = 1, #ALPHABET do
        local c = ALPHABET:sub(i, i)

        if lettersGuessed[c] == GUESSED_RIGHT then
            love.graphics.setColor(0, 1, 0, 1)
        elseif lettersGuessed[c] == GUESSED_WRONG then
            love.graphics.setColor(1, 0, 0, 1)
        end

        love.graphics.print(c, x, WINDOW_HEIGHT - 100)
        x = x + 32

        love.graphics.setColor(1, 1, 1, 1)
    end
end