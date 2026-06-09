/****** Object:  Table [dbo].[accounts]    Script Date: 6/9/2026 11:40:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[accounts](
	[id] [uniqueidentifier] NOT NULL,
	[user_id] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[currency] [nvarchar](10) NOT NULL,
	[balance] [decimal](15, 2) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 6/9/2026 11:40:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[id] [uniqueidentifier] NOT NULL,
	[user_id] [uniqueidentifier] NOT NULL,
	[account_id] [uniqueidentifier] NOT NULL,
	[amount] [decimal](15, 2) NOT NULL,
	[type] [nvarchar](10) NOT NULL,
	[category] [nvarchar](100) NOT NULL,
	[description] [nvarchar](500) NULL,
	[transaction_date] [datetime2](7) NOT NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 6/9/2026 11:40:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [uniqueidentifier] NOT NULL,
	[email] [nvarchar](255) NOT NULL,
	[full_name] [nvarchar](255) NULL,
	[created_at] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[accounts] ([id], [user_id], [name], [currency], [balance], [created_at]) VALUES (N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', N'11111111-1111-1111-1111-111111111111', N'Main Checking', N'EUR', CAST(0.00 AS Decimal(15, 2)), CAST(N'2024-12-01T10:00:00.0000000' AS DateTime2))
GO
INSERT [dbo].[accounts] ([id], [user_id], [name], [currency], [balance], [created_at]) VALUES (N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', N'11111111-1111-1111-1111-111111111111', N'Savings Account', N'EUR', CAST(0.00 AS Decimal(15, 2)), CAST(N'2024-12-01T10:00:00.0000000' AS DateTime2))
GO
INSERT [dbo].[accounts] ([id], [user_id], [name], [currency], [balance], [created_at]) VALUES (N'cccccccc-cccc-cccc-cccc-cccccccccccc', N'11111111-1111-1111-1111-111111111111', N'Travel Fund', N'USD', CAST(0.00 AS Decimal(15, 2)), CAST(N'2024-12-01T10:00:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0001-4000-8000-000123456789', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(2973.19 AS Decimal(15, 2)), N'INCOME', N'Freelance', N'Performance bonus', CAST(N'2026-03-02T11:07:00.0000000' AS DateTime2), CAST(N'2026-03-02T11:07:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0002-4000-8000-000124456772', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(3200.99 AS Decimal(15, 2)), N'INCOME', N'Rental Income', N'Performance bonus', CAST(N'2026-03-03T10:52:00.0000000' AS DateTime2), CAST(N'2026-03-03T10:52:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0003-4000-8000-000125456755', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(1353.38 AS Decimal(15, 2)), N'INCOME', N'Dividends', N'Rental income received', CAST(N'2026-03-04T18:14:00.0000000' AS DateTime2), CAST(N'2026-03-04T18:14:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0004-4000-8000-000126456738', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(1265.95 AS Decimal(15, 2)), N'INCOME', N'Salary', N'Monthly salary payment', CAST(N'2026-03-07T18:03:00.0000000' AS DateTime2), CAST(N'2026-03-07T18:03:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0005-4000-8000-000127456721', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(31.12 AS Decimal(15, 2)), N'EXPENSE', N'Utilities', N'Metro monthly pass', CAST(N'2026-03-07T15:41:00.0000000' AS DateTime2), CAST(N'2026-03-07T15:41:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0006-4000-8000-000128456704', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(294.58 AS Decimal(15, 2)), N'EXPENSE', N'Transport', N'Amazon order', CAST(N'2026-03-09T16:08:00.0000000' AS DateTime2), CAST(N'2026-03-09T16:08:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0007-4000-8000-000129456687', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(7.42 AS Decimal(15, 2)), N'EXPENSE', N'Rent', N'Weekly grocery run', CAST(N'2026-03-10T08:10:00.0000000' AS DateTime2), CAST(N'2026-03-10T08:10:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0008-4000-8000-000130456670', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(368.71 AS Decimal(15, 2)), N'EXPENSE', N'Rent', N'Amazon order', CAST(N'2026-03-12T16:40:00.0000000' AS DateTime2), CAST(N'2026-03-12T16:40:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0009-4000-8000-000131456653', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(583.03 AS Decimal(15, 2)), N'EXPENSE', N'Entertainment', N'Electricity bill', CAST(N'2026-03-13T14:31:00.0000000' AS DateTime2), CAST(N'2026-03-13T14:31:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0010-4000-8000-000132456636', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(317.88 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Amazon order', CAST(N'2026-03-13T10:24:00.0000000' AS DateTime2), CAST(N'2026-03-13T10:24:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0011-4000-8000-000133456619', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(279.22 AS Decimal(15, 2)), N'EXPENSE', N'Rent', N'Doctor visit', CAST(N'2026-03-15T17:12:00.0000000' AS DateTime2), CAST(N'2026-03-15T17:12:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0012-4000-8000-000134456602', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(522.98 AS Decimal(15, 2)), N'EXPENSE', N'Groceries', N'Dinner at restaurant', CAST(N'2026-03-18T18:01:00.0000000' AS DateTime2), CAST(N'2026-03-18T18:01:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0013-4000-8000-000135456585', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(221.40 AS Decimal(15, 2)), N'EXPENSE', N'Groceries', N'New jacket', CAST(N'2026-03-20T18:02:00.0000000' AS DateTime2), CAST(N'2026-03-20T18:02:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0014-4000-8000-000136456568', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(177.60 AS Decimal(15, 2)), N'EXPENSE', N'Utilities', N'Dinner at restaurant', CAST(N'2026-03-22T19:02:00.0000000' AS DateTime2), CAST(N'2026-03-22T19:02:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0015-4000-8000-000137456551', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(97.44 AS Decimal(15, 2)), N'EXPENSE', N'Transport', N'Amazon order', CAST(N'2026-03-24T15:04:00.0000000' AS DateTime2), CAST(N'2026-03-24T15:04:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0016-4000-8000-000138456534', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(226.81 AS Decimal(15, 2)), N'EXPENSE', N'Online Shopping', N'Metro monthly pass', CAST(N'2026-03-24T17:52:00.0000000' AS DateTime2), CAST(N'2026-03-24T17:52:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0017-4000-8000-000139456517', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(277.30 AS Decimal(15, 2)), N'EXPENSE', N'Entertainment', N'New jacket', CAST(N'2026-03-25T18:23:00.0000000' AS DateTime2), CAST(N'2026-03-25T18:23:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0018-4000-8000-000140456500', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(97.53 AS Decimal(15, 2)), N'EXPENSE', N'Entertainment', N'Doctor visit', CAST(N'2026-03-29T08:11:00.0000000' AS DateTime2), CAST(N'2026-03-29T08:11:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0019-4000-8000-000141456483', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(148.44 AS Decimal(15, 2)), N'EXPENSE', N'Online Shopping', N'Weekly grocery run', CAST(N'2026-03-30T09:04:00.0000000' AS DateTime2), CAST(N'2026-03-30T09:04:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000001-0020-4000-8000-000142456466', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(538.67 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Weekly grocery run', CAST(N'2026-03-30T17:19:00.0000000' AS DateTime2), CAST(N'2026-03-30T17:19:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0001-4000-8000-000223455089', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(1684.31 AS Decimal(15, 2)), N'INCOME', N'Bonus', N'Monthly salary payment', CAST(N'2026-04-02T17:26:00.0000000' AS DateTime2), CAST(N'2026-04-02T17:26:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0002-4000-8000-000224455072', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(2867.53 AS Decimal(15, 2)), N'INCOME', N'Bonus', N'Monthly salary payment', CAST(N'2026-04-06T09:38:00.0000000' AS DateTime2), CAST(N'2026-04-06T09:38:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0003-4000-8000-000225455055', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(2341.80 AS Decimal(15, 2)), N'INCOME', N'Freelance', N'Freelance project payment', CAST(N'2026-04-06T17:32:00.0000000' AS DateTime2), CAST(N'2026-04-06T17:32:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0004-4000-8000-000226455038', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(2127.33 AS Decimal(15, 2)), N'INCOME', N'Salary', N'Monthly salary payment', CAST(N'2026-04-08T19:17:00.0000000' AS DateTime2), CAST(N'2026-04-08T19:17:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0005-4000-8000-000227455021', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(545.50 AS Decimal(15, 2)), N'EXPENSE', N'Rent', N'Dinner at restaurant', CAST(N'2026-04-11T12:11:00.0000000' AS DateTime2), CAST(N'2026-04-11T12:11:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0006-4000-8000-000228455004', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(202.81 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Metro monthly pass', CAST(N'2026-04-13T16:37:00.0000000' AS DateTime2), CAST(N'2026-04-13T16:37:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0007-4000-8000-000229454987', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(571.79 AS Decimal(15, 2)), N'EXPENSE', N'Entertainment', N'Amazon order', CAST(N'2026-04-14T19:47:00.0000000' AS DateTime2), CAST(N'2026-04-14T19:47:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0008-4000-8000-000230454970', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(12.00 AS Decimal(15, 2)), N'EXPENSE', N'Online Shopping', N'Amazon order', CAST(N'2026-04-15T16:23:00.0000000' AS DateTime2), CAST(N'2026-04-15T16:23:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0009-4000-8000-000231454953', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(270.93 AS Decimal(15, 2)), N'EXPENSE', N'Online Shopping', N'New jacket', CAST(N'2026-04-15T19:35:00.0000000' AS DateTime2), CAST(N'2026-04-15T19:35:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0010-4000-8000-000232454936', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(158.02 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Weekly grocery run', CAST(N'2026-04-16T13:09:00.0000000' AS DateTime2), CAST(N'2026-04-16T13:09:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0011-4000-8000-000233454919', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(317.69 AS Decimal(15, 2)), N'EXPENSE', N'Rent', N'Weekly grocery run', CAST(N'2026-04-19T16:07:00.0000000' AS DateTime2), CAST(N'2026-04-19T16:07:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0012-4000-8000-000234454902', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(301.82 AS Decimal(15, 2)), N'EXPENSE', N'Clothing', N'Dinner at restaurant', CAST(N'2026-04-19T12:30:00.0000000' AS DateTime2), CAST(N'2026-04-19T12:30:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0013-4000-8000-000235454885', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(493.84 AS Decimal(15, 2)), N'EXPENSE', N'Dining Out', N'Weekly grocery run', CAST(N'2026-04-20T08:04:00.0000000' AS DateTime2), CAST(N'2026-04-20T08:04:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0014-4000-8000-000236454868', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(157.83 AS Decimal(15, 2)), N'EXPENSE', N'Entertainment', N'Electricity bill', CAST(N'2026-04-23T10:58:00.0000000' AS DateTime2), CAST(N'2026-04-23T10:58:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0015-4000-8000-000237454851', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(459.55 AS Decimal(15, 2)), N'EXPENSE', N'Transport', N'Metro monthly pass', CAST(N'2026-04-24T19:55:00.0000000' AS DateTime2), CAST(N'2026-04-24T19:55:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0016-4000-8000-000238454834', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(208.36 AS Decimal(15, 2)), N'EXPENSE', N'Healthcare', N'Netflix subscription', CAST(N'2026-04-24T15:49:00.0000000' AS DateTime2), CAST(N'2026-04-24T15:49:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0017-4000-8000-000239454817', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(206.82 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Cinema tickets', CAST(N'2026-04-25T19:34:00.0000000' AS DateTime2), CAST(N'2026-04-25T19:34:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0018-4000-8000-000240454800', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(36.30 AS Decimal(15, 2)), N'EXPENSE', N'Transport', N'Weekly grocery run', CAST(N'2026-04-25T12:06:00.0000000' AS DateTime2), CAST(N'2026-04-25T12:06:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0019-4000-8000-000241454783', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(571.27 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Cinema tickets', CAST(N'2026-04-26T08:26:00.0000000' AS DateTime2), CAST(N'2026-04-26T08:26:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000002-0020-4000-8000-000242454766', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(552.18 AS Decimal(15, 2)), N'EXPENSE', N'Dining Out', N'Netflix subscription', CAST(N'2026-04-28T18:02:00.0000000' AS DateTime2), CAST(N'2026-04-28T18:02:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0001-4000-8000-000323453389', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(2848.09 AS Decimal(15, 2)), N'INCOME', N'Bonus', N'Performance bonus', CAST(N'2026-05-01T10:30:00.0000000' AS DateTime2), CAST(N'2026-05-01T10:30:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0002-4000-8000-000324453372', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(2482.03 AS Decimal(15, 2)), N'INCOME', N'Rental Income', N'Performance bonus', CAST(N'2026-05-02T11:13:00.0000000' AS DateTime2), CAST(N'2026-05-02T11:13:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0003-4000-8000-000325453355', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(3022.42 AS Decimal(15, 2)), N'INCOME', N'Rental Income', N'Monthly salary payment', CAST(N'2026-05-02T08:15:00.0000000' AS DateTime2), CAST(N'2026-05-02T08:15:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0004-4000-8000-000326453338', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(965.69 AS Decimal(15, 2)), N'INCOME', N'Bonus', N'Freelance project payment', CAST(N'2026-05-04T17:52:00.0000000' AS DateTime2), CAST(N'2026-05-04T17:52:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0005-4000-8000-000327453321', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(51.90 AS Decimal(15, 2)), N'EXPENSE', N'Dining Out', N'Metro monthly pass', CAST(N'2026-05-05T13:17:00.0000000' AS DateTime2), CAST(N'2026-05-05T13:17:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0006-4000-8000-000328453304', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(499.57 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Netflix subscription', CAST(N'2026-05-07T14:52:00.0000000' AS DateTime2), CAST(N'2026-05-07T14:52:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0007-4000-8000-000329453287', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(318.92 AS Decimal(15, 2)), N'EXPENSE', N'Clothing', N'Doctor visit', CAST(N'2026-05-10T13:52:00.0000000' AS DateTime2), CAST(N'2026-05-10T13:52:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0008-4000-8000-000330453270', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(85.30 AS Decimal(15, 2)), N'EXPENSE', N'Entertainment', N'Netflix subscription', CAST(N'2026-05-10T15:57:00.0000000' AS DateTime2), CAST(N'2026-05-10T15:57:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0009-4000-8000-000331453253', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(517.94 AS Decimal(15, 2)), N'EXPENSE', N'Healthcare', N'Metro monthly pass', CAST(N'2026-05-11T16:08:00.0000000' AS DateTime2), CAST(N'2026-05-11T16:08:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0010-4000-8000-000332453236', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(128.35 AS Decimal(15, 2)), N'EXPENSE', N'Clothing', N'Metro monthly pass', CAST(N'2026-05-11T11:12:00.0000000' AS DateTime2), CAST(N'2026-05-11T11:12:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0011-4000-8000-000333453219', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(423.69 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Weekly grocery run', CAST(N'2026-05-14T13:27:00.0000000' AS DateTime2), CAST(N'2026-05-14T13:27:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0012-4000-8000-000334453202', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(94.23 AS Decimal(15, 2)), N'EXPENSE', N'Subscriptions', N'Weekly grocery run', CAST(N'2026-05-18T13:16:00.0000000' AS DateTime2), CAST(N'2026-05-18T13:16:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0013-4000-8000-000335453185', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(58.66 AS Decimal(15, 2)), N'EXPENSE', N'Utilities', N'Cinema tickets', CAST(N'2026-05-21T08:07:00.0000000' AS DateTime2), CAST(N'2026-05-21T08:07:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0014-4000-8000-000336453168', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(154.99 AS Decimal(15, 2)), N'EXPENSE', N'Dining Out', N'New jacket', CAST(N'2026-05-21T19:14:00.0000000' AS DateTime2), CAST(N'2026-05-21T19:14:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0015-4000-8000-000337453151', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(434.30 AS Decimal(15, 2)), N'EXPENSE', N'Utilities', N'New jacket', CAST(N'2026-05-26T17:11:00.0000000' AS DateTime2), CAST(N'2026-05-26T17:11:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0016-4000-8000-000338453134', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(532.51 AS Decimal(15, 2)), N'EXPENSE', N'Entertainment', N'Amazon order', CAST(N'2026-05-27T18:45:00.0000000' AS DateTime2), CAST(N'2026-05-27T18:45:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0017-4000-8000-000339453117', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(79.98 AS Decimal(15, 2)), N'EXPENSE', N'Clothing', N'Electricity bill', CAST(N'2026-05-27T19:57:00.0000000' AS DateTime2), CAST(N'2026-05-27T19:57:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0018-4000-8000-000340453100', N'11111111-1111-1111-1111-111111111111', N'cccccccc-cccc-cccc-cccc-cccccccccccc', CAST(116.53 AS Decimal(15, 2)), N'EXPENSE', N'Healthcare', N'Electricity bill', CAST(N'2026-05-27T13:33:00.0000000' AS DateTime2), CAST(N'2026-05-27T13:33:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0019-4000-8000-000341453083', N'11111111-1111-1111-1111-111111111111', N'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', CAST(201.21 AS Decimal(15, 2)), N'EXPENSE', N'Utilities', N'New jacket', CAST(N'2026-05-28T19:07:00.0000000' AS DateTime2), CAST(N'2026-05-28T19:07:00.0000000' AS DateTime2))
GO
INSERT [dbo].[transactions] ([id], [user_id], [account_id], [amount], [type], [category], [description], [transaction_date], [created_at]) VALUES (N'00000003-0020-4000-8000-000342453066', N'11111111-1111-1111-1111-111111111111', N'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', CAST(421.94 AS Decimal(15, 2)), N'EXPENSE', N'Groceries', N'Weekly grocery run', CAST(N'2026-05-30T19:45:00.0000000' AS DateTime2), CAST(N'2026-05-30T19:45:00.0000000' AS DateTime2))
GO
INSERT [dbo].[users] ([id], [email], [full_name], [created_at]) VALUES (N'11111111-1111-1111-1111-111111111111', N'james.carter@example.com', N'James Carter', CAST(N'2024-12-01T09:00:00.0000000' AS DateTime2))
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__AB6E6164BF66BCF7]    Script Date: 6/9/2026 11:40:13 PM ******/
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[accounts] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[accounts] ADD  DEFAULT ('EUR') FOR [currency]
GO
ALTER TABLE [dbo].[accounts] ADD  DEFAULT ((0)) FOR [balance]
GO
ALTER TABLE [dbo].[accounts] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[accounts]  WITH CHECK ADD  CONSTRAINT [FK_accounts_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[accounts] CHECK CONSTRAINT [FK_accounts_users]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [FK_transactions_accounts] FOREIGN KEY([account_id])
REFERENCES [dbo].[accounts] ([id])
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [FK_transactions_accounts]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [FK_transactions_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [FK_transactions_users]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD CHECK  (([type]='EXPENSE' OR [type]='INCOME'))
GO
