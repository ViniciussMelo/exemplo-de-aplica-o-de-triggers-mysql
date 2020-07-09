DROP TABLE IF EXISTS `login`;
CREATE TABLE `login` (
  `id` int NOT NULL AUTO_INCREMENT,
  `Login` varchar(45) NOT NULL,
  `Senha` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos` (
  `idproduto` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `descricao` varchar(45) NOT NULL,
  `valor` double NOT NULL,
  PRIMARY KEY (`idproduto`),
  UNIQUE KEY `id_UNIQUE` (`idproduto`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `produtos_log`;
CREATE TABLE `produtos_log` (
  `idproduto` int NOT NULL AUTO_INCREMENT,
  `idsequencia` int NOT NULL,
  `nome` varchar(45) NOT NULL,
  `descricao` varchar(45) NOT NULL,
  `valor` float NOT NULL,
  `idusuario` int NOT NULL,
  `data_alteracao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo_operacao` varchar(45) NOT NULL,
  PRIMARY KEY (`idproduto`,`idsequencia`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER $

CREATE TRIGGER tai_produtos AFTER INSERT
ON produtos
FOR EACH ROW
BEGIN
	DECLARE llSequencia integer;
    DECLARE llUsuario integer;
    
    SELECT ifnull(max(idsequencia) , 0) + 1
	  INTO llSequencia 
	  FROM produtos_log 
	 WHERE idproduto = NEW.idproduto;
    
    SELECT id 
	   INTO llUsuario
	   FROM login;

	insert into produtos_log (idproduto, idsequencia, nome, descricao, valor, idusuario, tipo_operacao)
    values(NEW.idproduto, llSequencia, NEW.nome, NEW.descricao, NEW.valor, llUsuario, 'INSERT');
END$

CREATE TRIGGER tau_produtos AFTER UPDATE
ON produtos
FOR EACH ROW
BEGIN
	DECLARE llSequencia integer;
    DECLARE llUsuario integer;
    
    SELECT ifnull(max(idsequencia) , 0) + 1
	  INTO llSequencia 
	  FROM produtos_log 
	 WHERE idproduto = NEW.idproduto;

    SELECT id 
	   INTO llUsuario
	   FROM login;

	insert into produtos_log (idproduto, idsequencia, nome, descricao, valor, idusuario, tipo_operacao)
    values(NEW.idproduto, llSequencia, NEW.nome, NEW.descricao, NEW.valor, llUsuario, 'UPDATE');
END$

CREATE TRIGGER tad_produtos AFTER DELETE
ON produtos
FOR EACH ROW
BEGIN
	DECLARE llSequencia integer;
    DECLARE llUsuario integer;
    
    SELECT ifnull(max(idsequencia) , 0) + 1
	  INTO llSequencia 
	  FROM produtos_log 
	 WHERE idproduto = OLD.idproduto;

    SELECT id 
	   INTO llUsuario
	   FROM login;

	insert into produtos_log (idproduto, idsequencia, nome, descricao, valor, idusuario, tipo_operacao)
    values(OLD.idproduto, llSequencia, OLD.nome, OLD.descricao, OLD.valor, llUsuario, 'DELETE');
END$

DELIMITER ;

INSERT INTO `atividades_bd`.`login` (`id`, `Login`, `Senha`) VALUES ('1', 'vini', 'vini');

INSERT INTO `atividades_bd`.`produtos` (`idproduto`, `nome`, `descricao`, `valor`) VALUES ('1', 'caneta', 'azul', '2');
SELECT * FROM atividades_bd.produtos;
SELECT * FROM atividades_bd.produtos_log;

UPDATE `atividades_bd`.`produtos` SET `descricao` = 'azulada' WHERE (`idproduto` = '1');
SELECT * FROM atividades_bd.produtos;
SELECT * FROM atividades_bd.produtos_log;

DELETE FROM `atividades_bd`.`produtos` WHERE (`idproduto` = '1');
SELECT * FROM atividades_bd.produtos;
SELECT * FROM atividades_bd.produtos_log;