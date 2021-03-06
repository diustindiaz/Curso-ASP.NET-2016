USE [DBClinica_test]
GO
/****** Object:  StoredProcedure [dbo].[spAccesoSistema]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAccesoSistema]
( @prmUser varchar(50),
  @prmPass varchar(50)
)
AS
	BEGIN
		SELECT E.idEmpleado, E.usuario, E.clave, E.nombres, E.apPaterno, E.apMaterno, E.nroDocumento
		FROM Empleado E
		WHERE E.usuario = @prmUser AND E.clave = @prmPass
	END
GO
/****** Object:  StoredProcedure [dbo].[spActualizarDatosPaciente]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarDatosPaciente]
(@prmIdPaciente int,
@prmDireccion varchar(300))
as
	begin
		update Paciente
		set Paciente.direccion = @prmDireccion
		where Paciente.idPaciente = @prmIdPaciente
	end
GO
/****** Object:  StoredProcedure [dbo].[spActualizarEstadoCita]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarEstadoCita]
(@prmIdCita INT, @prmEstado varchar(1))
AS
	BEGIN
		UPDATE Cita
		SET estado = @prmEstado -- Atendido
		WHERE idCita = @prmIdCita
	END
GO
/****** Object:  StoredProcedure [dbo].[spActualizarHorarioAtencion]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spActualizarHorarioAtencion]
(@prmIdMedico int,
 @prmIdHorario int,
 @prmFecha datetime,
 @prmHora varchar(5)
)
AS
	BEGIN
		DECLARE @idHora int;

		SET @idHora = (SELECT H.idHora FROM Hora  H WHERE H.hora = RTRIM(@prmHora));

		UPDATE HA
		SET HA.fecha = @prmFecha,
		    HA.idHoraInicio = @idHora
		FROM HorarioAtencion HA
		WHERE HA.idHorarioAtencion = @prmIdHorario
		AND HA.idMedico = @prmIdMedico
		
	END
GO
/****** Object:  StoredProcedure [dbo].[spBuscarMedico]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarMedico] 
(@prmDni varchar(8))
AS
	BEGIN
		SELECT M.idMedico
			 , E.idEmpleado
			 , E.nombres as nombre
			 , E.apPaterno
			 , E.apMaterno
			 , ES.idEspecialidad
			 , ES.descripcion
			 , M.estado as estadoMedico
		FROM Medico M 
		INNER JOIN Empleado E ON (M.idEmpleado = E.idEmpleado)
		INNER JOIN Especialidad ES ON (M.idEspecialidad = ES.idEspecialidad)
		WHERE M.estado = 1
		AND E.nroDocumento = @prmDni
	END
GO
/****** Object:  StoredProcedure [dbo].[spBuscarPacienteDNI]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarPacienteDNI]
(@prmDni varchar(10)
)
AS
	BEGIN
		SELECT P.idPaciente
		     , P.nombres AS Nombres
			 , P.apPaterno AS ApPaterno
			 , P.apMaterno AS ApMaterno
			 , P.telefono AS Telefono
			 , P.edad AS Edad
			 , P.sexo AS Sexo
		FROM Paciente P
		WHERE nroDocumento = @prmDni
	END
GO
/****** Object:  StoredProcedure [dbo].[spBuscarPacienteIdCita]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spBuscarPacienteIdCita]
(@prmIdCita INT)
AS
	BEGIN
		DECLARE @prmIdPaciente INT
		SET @prmIdPaciente = (SELECT idPaciente FROM Cita WHERE idCita = @prmIdCita)
		
		SELECT idPaciente, nombres, apPaterno, apMaterno, edad, sexo
		FROM  Paciente
		WHERE idPaciente = @prmIdPaciente
	END
GO
/****** Object:  StoredProcedure [dbo].[spEditarHorarioAtencion]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEditarHorarioAtencion]
( @prmIdHorarioAtencion int,
  @prmIdMedico int,
  @prmFecha datetime,
  @prmHora varchar(6)
)
AS
	BEGIN
		DECLARE @idHora int;
		SET @idHora = (SELECT idHora FROM Hora WHERE hora =  RTRIM(@prmHora));
	
		UPDATE HA
		SET HA.fecha = @prmFecha,
		    HA.idHoraInicio = @idHora
		FROM HorarioAtencion HA 
		JOIN Hora H ON (HA.idHoraInicio = H.idHora)
		WHERE H.idHora = @idHora
		AND HA.idHorarioAtencion = @prmIdHorarioAtencion
		AND HA.idMedico = @prmIdMedico
	END
GO
/****** Object:  StoredProcedure [dbo].[spEliminarHorarioAtencion]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarHorarioAtencion]
( @prmIdHorarioAtencion int
)
AS
	BEGIN
		UPDATE HorarioAtencion
		SET estado = 0
		WHERE idHorarioAtencion = @prmIdHorarioAtencion
	END
GO
/****** Object:  StoredProcedure [dbo].[spEliminarPaciente]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spEliminarPaciente]
(@prmIdPaciente int)
AS
	BEGIN
		UPDATE Paciente
		SET estado = 0
		WHERE idPaciente = @prmIdPaciente
	END
GO
/****** Object:  StoredProcedure [dbo].[spListaHorariosAtencion]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListaHorariosAtencion]
(@prmIdMedico int
)
AS
	BEGIN
		SELECT M.idMedico, HA.idHorarioAtencion, HA.fecha, H.hora
		FROM Medico M
		INNER JOIN HorarioAtencion HA ON (M.idMedico = HA.idMedico)
		INNER JOIN Hora H ON (HA.idHoraInicio = H.idHora)
		WHERE M.idMedico = @prmIdMedico 
		AND CONVERT(VARCHAR(10), HA.fecha, 103) >= CONVERT(VARCHAR(10), GETDATE(), 103)
		AND HA.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarCitas]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarCitas]
AS
	BEGIN
		SELECT C.idCita, C.idMedico, C.idPaciente, C.fechaReserva, C.hora, 
			   P.nombres, P.apPaterno, P.apMaterno, P.edad, P.sexo, 
			   P.nroDocumento, P.direccion
		FROM Cita AS C inner join Paciente AS P ON C.idPaciente = P.idPaciente
		WHERE --CONVERT(VARCHAR(10), C.fechaReserva, 103) = (SELECT CONVERT(VARCHAR(10), GETDATE(), 103)) AND
			  C.estado = 'P' AND -- P = 'Pendiente', A = 'Atendida'
			  P.estado = 1
		ORDER BY C.hora ASC
	END

GO
/****** Object:  StoredProcedure [dbo].[spListarEspecialidades]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarEspecialidades]
AS
	BEGIN
		SELECT E.idEspecialidad, E.descripcion
		FROM Especialidad E
		WHERE E.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarPacientes]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarPacientes]
AS
	BEGIN
		SELECT P.idPaciente
		     , P.nombres
			 , P.apPaterno
			 , P.apMaterno
			 , P.edad
			 , P.sexo
			 , P.nroDocumento
			 , P.direccion
		FROM Paciente P
		WHERE P.estado = 1
	END
GO
/****** Object:  StoredProcedure [dbo].[spListarSexo]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spListarSexo]
AS	
	SET NOCOUNT ON
	BEGIN
		SELECT 'Femenino' idSexo
		     , 'Femenino' nombre
		UNION 
		SELECT 'Masculino' idSexo
		     , 'Masculino' nombre
	END

	



GO
/****** Object:  StoredProcedure [dbo].[spMenuPorEmpleado]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMenuPorEmpleado] 
(@prmIdEmpleado int)
AS
	BEGIN
		SELECT M.idMenu, 
			   M.nombre, M.url, 
			   M.isSubmenu, 
			   ISNULL(M.idMenuParent, 0) idMenuParent, 
			   M.estado MEstado,
			   P.estado,
			   M.show
		FROM Menu M INNER JOIN 
			 Permisos P ON (M.idMenu = P.idMenu) INNER JOIN 
			 Empleado E ON (E.idEmpleado = P.idEmpleado)
		WHERE E.idEmpleado = @prmIdEmpleado 
		  AND P.estado = 1	
		ORDER BY M.orden
	END



GO
/****** Object:  StoredProcedure [dbo].[spRegistrarCita]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarCita]
( @idMedico int,
  @idPaciente int,
  @fechaReserva datetime,
  @hora varchar(5)
)
AS
	BEGIN
		INSERT INTO Cita(idMedico, idPaciente, fechaReserva, estado, hora)
		VALUES(@idMedico, @idPaciente, @fechaReserva, 'P', @hora)
	END


GO
/****** Object:  StoredProcedure [dbo].[spRegistrarDiagnostico]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarDiagnostico]
(@prmIdPaciente INT,
 @prmObservacion VARCHAR(500),
 @prmDiagnostico VARCHAR(500)
 )
AS
	SET NOCOUNT ON
	BEGIN
		DECLARE @prmFecha DATETIME = GETDATE()
		DECLARE @prmEstado BIT = 1
		DECLARE @prmIdHistoriaClinica INT
		-- guardar la historia clinica
		IF NOT EXISTS(SELECT TOP 1 idHistoriaClinica FROM HistoriaClinica WHERE idPaciente = @prmIdPaciente)
			BEGIN
				INSERT INTO HistoriaClinica(idPaciente, fechaApertura, estado)
				VALUES(@prmIdPaciente, @prmFecha, @prmEstado)

				SET @prmIdHistoriaClinica = SCOPE_IDENTITY()
			END
		ELSE
			BEGIN
				SET @prmIdHistoriaClinica = (SELECT TOP 1 idHistoriaClinica FROM HistoriaClinica WHERE idPaciente = @prmIdPaciente)
			END

		-- guardar el diagnostico	
		INSERT INTO Diagnostico(idHistoriaClinica, fechaEmision, observacion, estado)
		VALUES(@prmIdHistoriaClinica, @prmFecha, @prmObservacion, @prmEstado)	
	END
GO
/****** Object:  StoredProcedure [dbo].[spRegistrarHorarioAtencion]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarHorarioAtencion]
(@prmIdMedico int,
 @prmHora varchar(5),
 @prmFecha datetime
)
AS
	BEGIN
		-- TRY CATCH
		BEGIN TRY
			DECLARE @hora int;
			DECLARE @idHorarioAtencion int;
			
			-- OBTENER EL ID RESPECTIVO DEL PARAMETRO HORA
			SET @hora = (SELECT H.idHora FROM Hora H WHERE H.hora = @prmHora);
						
			-- INSERT
			INSERT INTO HorarioATencion(idMedico, fecha, idHoraInicio, estado)
			VALUES(@prmIdMedico, @prmFecha, @hora, 1); 
			
			-- OBTENER EL ULTIMO REGISTRO INSERTADO EN LA TABLA HORARIOATENCION
			SET @idHorarioAtencion = SCOPE_IDENTITY();

			-- SELECT
			SELECT HA.idHorarioAtencion, HA.fecha, H.idHora, H.hora, HA.estado
			FROM HorarioAtencion HA
			INNER JOIN Hora H ON(HA.idHoraInicio = H.idHora)
			WHERE HA.idHorarioAtencion = @idHorarioAtencion
		END TRY
		BEGIN CATCH
			ROLLBACK;
			-- RAISERROR('',,,,'')
			-- PRINT 'mensaje'
		END CATCH
	END
GO
/****** Object:  StoredProcedure [dbo].[spRegistrarPaciente]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRegistrarPaciente]
(
@prmNombres VARCHAR(50),
@prmApPaterno VARCHAR(50),
@prmApMaterno VARCHAR(50),
@prmEdad INT,
@prmSexo CHAR(1),
@prmNroDoc VARCHAR(8), 
@prmDireccion VARCHAR(150),
@prmTelefono VARCHAR(20),
@prmEstado bit
)
AS
	BEGIN
		INSERT INTO Paciente(nombres, apPaterno, apMaterno, edad, sexo, nroDocumento, direccion, telefono, estado)
		VALUES(@prmNombres, @prmApPaterno, @prmApMaterno, @prmEdad, @prmSexo, @prmNroDoc, @prmDireccion, @prmTelefono, @prmEstado);
	END
GO
/****** Object:  Table [dbo].[Cita]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cita](
	[idCita] [int] IDENTITY(1,1) NOT NULL,
	[idMedico] [int] NOT NULL,
	[idPaciente] [int] NOT NULL,
	[fechaReserva] [datetime] NULL,
	[observacion] [varchar](350) NULL,
	[estado] [char](1) NULL,
	[hora] [varchar](6) NULL,
 CONSTRAINT [PK_Cita] PRIMARY KEY CLUSTERED 
(
	[idCita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Diagnostico]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Diagnostico](
	[idDiagnostico] [int] IDENTITY(1,1) NOT NULL,
	[idHistoriaClinica] [int] NOT NULL,
	[fechaEmision] [datetime] NULL,
	[observacion] [varchar](500) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Diagnostico] PRIMARY KEY CLUSTERED 
(
	[idDiagnostico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DiaSemana]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DiaSemana](
	[idDiaSemana] [int] IDENTITY(1,1) NOT NULL,
	[nombreDiaSemana] [varchar](50) NULL,
 CONSTRAINT [PK_DiaSemana] PRIMARY KEY CLUSTERED 
(
	[idDiaSemana] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Empleado]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Empleado](
	[idEmpleado] [int] IDENTITY(1,1) NOT NULL,
	[idTipoEmpleado] [int] NOT NULL,
	[nombres] [varchar](50) NULL,
	[apPaterno] [varchar](20) NULL,
	[apMaterno] [varchar](20) NULL,
	[nroDocumento] [varchar](8) NULL,
	[estado] [bit] NULL,
	[imagen] [varchar](500) NULL,
	[usuario] [varchar](50) NULL,
	[clave] [varchar](50) NULL,
 CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED 
(
	[idEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Especialidad]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Especialidad](
	[idEspecialidad] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](25) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Especialidad] PRIMARY KEY CLUSTERED 
(
	[idEspecialidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HistoriaClinica]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistoriaClinica](
	[idHistoriaClinica] [int] IDENTITY(1,1) NOT NULL,
	[idPaciente] [int] NULL,
	[fechaApertura] [datetime] NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_HistoriaClinica] PRIMARY KEY CLUSTERED 
(
	[idHistoriaClinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Hora]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hora](
	[idHora] [int] IDENTITY(1,1) NOT NULL,
	[hora] [varchar](6) NULL,
 CONSTRAINT [PK_Hora] PRIMARY KEY CLUSTERED 
(
	[idHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HorarioAtencion]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HorarioAtencion](
	[idHorarioAtencion] [int] IDENTITY(1,1) NOT NULL,
	[idMedico] [int] NOT NULL,
	[idHoraInicio] [int] NOT NULL,
	[fecha] [datetime] NULL,
	[fechaFin] [date] NULL,
	[estado] [bit] NULL,
	[idDiaSemana] [int] NULL,
 CONSTRAINT [PK_HorarioAtencion] PRIMARY KEY CLUSTERED 
(
	[idHorarioAtencion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Medico]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medico](
	[idMedico] [int] IDENTITY(1,1) NOT NULL,
	[idEmpleado] [int] NOT NULL,
	[idEspecialidad] [int] NOT NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_Medico] PRIMARY KEY CLUSTERED 
(
	[idMedico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Paciente]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Paciente](
	[idPaciente] [int] IDENTITY(1,1) NOT NULL,
	[nombres] [varchar](50) NULL,
	[apPaterno] [varchar](20) NULL,
	[apMaterno] [varchar](20) NULL,
	[edad] [int] NULL,
	[sexo] [char](1) NULL,
	[nroDocumento] [varchar](8) NULL,
	[direccion] [varchar](150) NULL,
	[telefono] [varchar](20) NULL,
	[estado] [bit] NULL,
	[imagen] [varchar](500) NULL,
 CONSTRAINT [PK_Paciente] PRIMARY KEY CLUSTERED 
(
	[idPaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TipoEmpleado]    Script Date: 21/08/2018 1:12:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TipoEmpleado](
	[idTipoEmpleado] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](25) NULL,
	[estado] [bit] NULL,
 CONSTRAINT [PK_TipoEmpleado] PRIMARY KEY CLUSTERED 
(
	[idTipoEmpleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Cita]  WITH CHECK ADD  CONSTRAINT [FK_Cita_Medico] FOREIGN KEY([idMedico])
REFERENCES [dbo].[Medico] ([idMedico])
GO
ALTER TABLE [dbo].[Cita] CHECK CONSTRAINT [FK_Cita_Medico]
GO
ALTER TABLE [dbo].[Cita]  WITH CHECK ADD  CONSTRAINT [FK_Cita_Paciente] FOREIGN KEY([idPaciente])
REFERENCES [dbo].[Paciente] ([idPaciente])
GO
ALTER TABLE [dbo].[Cita] CHECK CONSTRAINT [FK_Cita_Paciente]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_TipoEmpleado] FOREIGN KEY([idTipoEmpleado])
REFERENCES [dbo].[TipoEmpleado] ([idTipoEmpleado])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_TipoEmpleado]
GO
ALTER TABLE [dbo].[HistoriaClinica]  WITH CHECK ADD  CONSTRAINT [FK_HistoriaClinica_Paciente] FOREIGN KEY([idPaciente])
REFERENCES [dbo].[Paciente] ([idPaciente])
GO
ALTER TABLE [dbo].[HistoriaClinica] CHECK CONSTRAINT [FK_HistoriaClinica_Paciente]
GO
ALTER TABLE [dbo].[HorarioAtencion]  WITH CHECK ADD  CONSTRAINT [FK_HorarioAtencion_DiaSemana] FOREIGN KEY([idDiaSemana])
REFERENCES [dbo].[DiaSemana] ([idDiaSemana])
GO
ALTER TABLE [dbo].[HorarioAtencion] CHECK CONSTRAINT [FK_HorarioAtencion_DiaSemana]
GO
ALTER TABLE [dbo].[HorarioAtencion]  WITH CHECK ADD  CONSTRAINT [FK_HorarioAtencion_Hora] FOREIGN KEY([idHoraInicio])
REFERENCES [dbo].[Hora] ([idHora])
GO
ALTER TABLE [dbo].[HorarioAtencion] CHECK CONSTRAINT [FK_HorarioAtencion_Hora]
GO
ALTER TABLE [dbo].[HorarioAtencion]  WITH CHECK ADD  CONSTRAINT [FK_HorarioAtencion_Medico] FOREIGN KEY([idMedico])
REFERENCES [dbo].[Medico] ([idMedico])
GO
ALTER TABLE [dbo].[HorarioAtencion] CHECK CONSTRAINT [FK_HorarioAtencion_Medico]
GO
ALTER TABLE [dbo].[Medico]  WITH CHECK ADD  CONSTRAINT [FK_Medico_Empleado] FOREIGN KEY([idEmpleado])
REFERENCES [dbo].[Empleado] ([idEmpleado])
GO
ALTER TABLE [dbo].[Medico] CHECK CONSTRAINT [FK_Medico_Empleado]
GO
ALTER TABLE [dbo].[Medico]  WITH CHECK ADD  CONSTRAINT [FK_Medico_Especialidad] FOREIGN KEY([idEspecialidad])
REFERENCES [dbo].[Especialidad] ([idEspecialidad])
GO
ALTER TABLE [dbo].[Medico] CHECK CONSTRAINT [FK_Medico_Especialidad]
GO
