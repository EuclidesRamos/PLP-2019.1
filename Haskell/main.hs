import System.IO
import Data.Char
import System.Random
import Data.List.Split
import Data.List
import Control.Monad



-- Funcao que só mostra as instrucoes do jogo                
instrucoes :: String
instrucoes = "\n===== Instrucoes =====\nO PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:\n-> Singleplayer ou Multiplayer\nCada partida possui 12 perguntas, divididas em 4 areas de conhecimento:\n- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas\nVoce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)\nAlehm disso, haverao dicas limitadas disponiveis:\n- Eliminar alternativas: elimina duas alternativas\n- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa\n- Pular pergunta: pula para a proxima pergunta\nA cada inicio de partida, voce tera 1 dica de cada\nPara obter mais dicas, voce devera responder a pergunta em menos de 5 segundos\nSe ja tiver sido usado alguma dica, ela sera reposta. Caso contrario, a dica recebida sera aleatoria\nAlem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"

-- Funcao principal do programa. Executa a parte logica atraves de chamadas de funcoes secundarias
main :: IO ()
main = do 
    ent <- entradaUser ("\n===== PerguntUP =====" ++ "\nby GERIGE" ++ "\n\n(1) Ver as instrucoes\n(2) Seguir para o jogo\n(3) Sair\n")
    case ent of
        "1" -> -- Ver as instrucoes chamando a funcao "instrucoes"
            do
                putStrLn (instrucoes)
                main -- Chama novamente o "main" apos a execucao
                return() -- Fecha a funcao apos toda a recursividade
        "2" -> -- Seguir para o jogo em si chamando a funcao "criarPartida"
            do
                criarPartida -- Executa a funcao que inicia o menu para comecar uma partida
                return() -- Fecha a funcao apos toda a recursividade
        "3" -> -- Sai do jogo
            return()  -- Fecha a funcao apos toda a recursividade
        _ -> -- Qualquer outra entradaUser que nao seja "1", "2" ou "3" sera ignorada e a funcao sera chamada novamente
            do
                putStrLn ("\nOpcao Invalida!\n")
                main -- Chamada do "main" para entradas invalidas
                return()  -- Fecha a funcao apos toda a recursividade

-- Funcao que cuida da criacao da partida atraves de chamadas de funcoes secundarias
criarPartida :: IO ()
criarPartida = do
    ent <- entradaUser ("\nDeseja iniciar uma nova partida?\n(1) Sim\n(2) Nao\n")
    case ent of
        "1" -> -- Iniciar um nova partida chamando a funcao "modoJogo"
            do
                modoJogo
                criarPartida -- Chama novamente a funcao "criarPartida" caso o usuario deseje jogar novamente
                return()  -- Fecha a funcao apos toda a recursividade
        "2" -> -- Fecha o jogo e retorna para o "main"
            do
                putStrLn ("\nObrigado por jogar!\n")
                main -- Chama o "main" para que o programa reinicie
                return()  -- Fecha a funcao apos toda a recursividade
        _ ->
            do
                putStrLn ("\nOpcao Invalida!\n")
                criarPartida -- Chama a funcao 
                return()  -- Fecha a funcao apos toda a recursividade

-- Funcao que 
modoJogo :: IO ()
modoJogo = do
    ent <- entradaUser ("\nQual a forma de jogar?\n(1) SinglePlayer\n(2) MultiPlayer\n")
    case ent of
        "1" ->
            do
                singlePlayer
                return()  -- Fecha a funcao apos toda a recursividade
        "2" ->
            do
                putStrLn ("\nMultiPlayer\n")
                return()  -- Fecha a funcao apos toda a recursividade
        _ ->
            do
                putStrLn ("\nOpcao Invalida!\n")
                modoJogo
                return()  -- Fecha a funcao apos toda a recursividade

entradaUser :: String -> IO String
entradaUser ent = do
    putStrLn (ent)
    getLine

-- Modo SinglePlayer
singlePlayer :: IO ()
singlePlayer = do

    -- Definir "VARIÀVEIS"

    ent <- entradaUser("\nNome do Jogador:")
    arq <- readFile "perguntas.txt"

    printPergunta12 ent 12

    acertos <- contaAcertos
    putStr ("\nSua pontuacao final: ")
    putStrLn (show $ acertos)

    
    let newArq = arq
    when (length newArq > 0) $
        writeFile "perguntas.txt" newArq

    escrita (ent, pontuacaoAcertos acertos)

exibeRanking :: IO ()
exibeRanking = do
    arq <- readFile "ranking.txt"
    putStr ("====== RANKING ======")
    printa10Users 1

printa10Users :: Int -> IO ()
printa10Users n
    | n == 11 = return ()
    | otherwise = do
        arq <- readFile "ranking.txt"
        let linha = splitOn "\r\n" arq
        putStr $ ((show n) ++ ". ")
        putStr $ show (head (splitOn ":" (linha !! (length linha -2))))
        putStr (" - ")
        putStr $ show (last (splitOn ":" (linha !! (length linha -2))))
        printa10Users (n+1)        
                            


        
multiPlayer :: IO ()
multiPlayer = do
    putStr ("\n==== Jogador 1 ====\n")
    singlePlayer
    rank <- readFile "ranking.txt"
    let rankSplit = splitOn "\r\n" rank
    let p1 = read (last (splitOn ":" (rankSplit !! (length rankSplit -2)))) :: Int

    putStr ("\n==== Jogador 2 ====\n")
    singlePlayer
    rank <- readFile "ranking.txt"
    let rankSplit = splitOn "\r\n" rank
    let p2 = read (last (splitOn ":" (rankSplit !! (length rankSplit -2)))) :: Int

    if (p1 > p2)
        then do
            putStrLn ("\nJogador 1 venceu!\n")
        else if (p2 > p1)
            then do
                putStrLn ("\nJogador 2 venceu!\n")
            else do
                putStrLn ("\nEmpate!\n")


pontuacaoAcertos :: Int -> Int
pontuacaoAcertos acertos = (acertos * 50) div 12

-- pontuacaoTempo :: Int -> Int
-- pontuacaoTempo tempoTotal = 50 - ((tempoTotal - 60) * (50/120))

-- pontuacaoFinal :: Int
-- pontuacaoFinal =
--     if (pontuacaoTempo tempoTotal > 50)
--         then
--             if (ceiling (pontuacaoAcertos acertos + 50) < 0)
--                 then
--                     0
--                 else
--                     ceiling (pontuacaoAcertos acertos + 50)
--         else
--             if (ceiling (pontuacaoAcertos acertos + pontuacaoTempo tempoTotal) < 0)
--                 then
--                     0
--                 else
--                     ceiling (pontuacaoAcertos acertos + pontuacaoTempo tempoTotal)
    

printPergunta12 :: String -> Int -> IO ()
printPergunta12 nome n
    | n == 0 = return ()
    | otherwise = do
        arq <- readFile "perguntas.txt"
        gerandoPerguntaAleatoria arq nome
        printPergunta12 nome (n-1)
        


escrita :: (String,Int) -> IO ()
escrita inth = do
    arq <- readFile "ranking.txt"
    let newArq = arq ++ (fst inth ++ ":" ++ show (snd inth) ++ "\r\n")
    when (length newArq > 0) $
        writeFile "ranking.txt" newArq

    
gerandoPerguntaAleatoria :: String -> String -> IO ()
gerandoPerguntaAleatoria arq nome = do

    -- Tirar pergunta da Lista

    let lista = splitOn "---" arq
    num <- randomRIO (0,47::Int)
    let pergunta = lista !! num

    if (drop 11 ((splitOn "\r\n" (pergunta)) !! 7) == "-RESPc") || (drop 11 ((splitOn "\r\n" (pergunta)) !! 7) == "RESPe")
        then do
            gerandoPerguntaAleatoria arq nome
        else
            do
                putStrLn ("\n==== Placar ====")
                erros <- contaErros
                acertos <- contaAcertos
                putStr ("Erros:")
                putStrLn (show $ erros)
                putStr ("Acertos:")
                putStrLn (show $ acertos)
                printaPergunta nome lista num
    

contaErros :: IO Int
contaErros = do
    arq <- readFile "perguntas.txt"
    let erros = length (splitOn "-RESPe" arq) - 1 
    return (erros)

contaAcertos :: IO Int
contaAcertos = do
    arq <- readFile "perguntas.txt"
    let acertos = length (splitOn "-RESPc" arq) - 1
    return (acertos)

                
printaPergunta :: String -> [String] -> Int -> IO ()
printaPergunta nome lista num = do
    let perg = lista !! num
    let pergunta = drop 10 ((splitOn "\r\n" (perg)) !! 0)
        letraA = ((splitOn "\r\n" (perg)) !! 1)
        letraB = ((splitOn "\r\n" (perg)) !! 2)
        letraC = ((splitOn "\r\n" (perg)) !! 3)
        letraD = ((splitOn "\r\n" (perg)) !! 4)
        letraE = ((splitOn "\r\n" (perg)) !! 5)
        tipo = "\n" ++ ((splitOn "\r\n" (perg)) !! 6)
        resposta = drop 10 ((splitOn "\r\n" (perg)) !! 7)
    
    putStrLn (tipo)
    putStrLn (pergunta)
    putStrLn (letraA)
    putStrLn (letraB)
    putStrLn (letraC)
    putStrLn (letraD)
    putStrLn (letraE)
    putStrLn (resposta)
    putStrLn ("\np: Pedir dica\n")

    resp <- entradaUser("\nResposta:\n")
    if (resp `elem` ["a","b","c","d","e","p"])
        then if (resp == resposta)
            then do
                putStrLn ("\nResposta certa!\n")
                let newArq = ((intercalate "---" (take num lista)) ++ "---" ++ (intercalate "---" [perg ++ "-RESPc"]) ++ "---" ++ (intercalate "---" (drop (num+1) lista)))
                when (length newArq > 0) $
                    writeFile "perguntas.txt" newArq
                
            else do
                case resp of
                    "p" ->
                        do
                            ajuda nome lista num
                            return ()
                    _ ->
                        do
                            putStrLn ("\nResposta errada.\n")
                            let newArq = ((intercalate "---" (take num lista)) ++ "---" ++ (intercalate "---" [perg ++ "-RESPe"]) ++ "---" ++ (intercalate "---" (drop (num+1) lista)))
                            when (length newArq > 0) $
                                writeFile "perguntas.txt" newArq
                            
        else do
            putStrLn ("\nResposta invalida!\n")
            printaPergunta nome lista num
            return ()

ajuda :: String -> [String] -> Int -> IO ()
ajuda nome lista num = do
    arq <- readFile "perguntas.txt"
    
    if (last lista == nome ++ "dica1") || (last lista == nome ++ "dica2") || (last lista == nome ++ "dica3")
        
        then do
            putStrLn ("\nVoce nao tem mais dicas para essa pergunta\n")
            printaPergunta nome lista num
            return()
    else do
        ajuda <- entradaUser("\n(1) Dica 1\n(2) Dica 2\n(3) Dica 3\n")
        case ajuda of
            "1" ->
                do
                    putStrLn ("\ndica um\n")
                    let newArq = arq ++ "\r\n---" ++ nome ++ "dica1"
                    when (length newArq > 0) $
                        writeFile "perguntas.txt" newArq
                    printaPergunta nome (lista ++ [nome ++ "dica1"]) num
                    return ()
            "2" ->
                do
                    putStrLn ("\ndica dois\n")
                    let newArq = arq ++ "\r\n---" ++ nome ++ "dica1"
                    when (length newArq > 0) $
                        writeFile "perguntas.txt" newArq
                    printaPergunta nome (lista ++ [nome ++ "dica2"]) num
                    return ()
            "3" ->
                do
                    putStrLn ("\ndica tres\n")
                    let newArq = arq ++ "\r\n---" ++ nome ++ "dica1"
                    when (length newArq > 0) $
                        writeFile "perguntas.txt" newArq
                    printaPergunta nome (lista ++ [nome ++ "dica3"]) num
                    return ()