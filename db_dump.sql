--
-- PostgreSQL database dump
--

\restrict qfb0ip1M9zirAxAWXIkSCOAwFFrHFxAs1fB5f3yW5KIyM3JeN4tquCazFrXjgmy

-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 15.15 (Debian 15.15-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: accounttype; Type: TYPE; Schema: public; Owner: dev_admin
--

CREATE TYPE public.accounttype AS ENUM (
    'ADMIN',
    'DEFAULT'
);


ALTER TYPE public.accounttype OWNER TO dev_admin;

--
-- Name: mailstate; Type: TYPE; Schema: public; Owner: dev_admin
--

CREATE TYPE public.mailstate AS ENUM (
    'RECEIVED',
    'PROCESSED',
    'FAILED'
);


ALTER TYPE public.mailstate OWNER TO dev_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: dev_admin
--

CREATE TABLE public.account (
    id integer NOT NULL,
    name character varying NOT NULL,
    info text,
    is_active boolean NOT NULL,
    account_type public.accounttype DEFAULT 'DEFAULT'::public.accounttype NOT NULL
);


ALTER TABLE public.account OWNER TO dev_admin;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: dev_admin
--

CREATE SEQUENCE public.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_id_seq OWNER TO dev_admin;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev_admin
--

ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: dev_admin
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO dev_admin;

--
-- Name: mail; Type: TABLE; Schema: public; Owner: dev_admin
--

CREATE TABLE public.mail (
    id integer NOT NULL,
    time_received timestamp(0) with time zone NOT NULL,
    sender character varying NOT NULL,
    recipient character varying NOT NULL,
    subject character varying NOT NULL,
    state public.mailstate NOT NULL,
    body_url character varying NOT NULL,
    raw_email_url character varying NOT NULL,
    job_results json,
    errors json
);


ALTER TABLE public.mail OWNER TO dev_admin;

--
-- Name: mail_cache; Type: TABLE; Schema: public; Owner: dev_admin
--

CREATE TABLE public.mail_cache (
    time_received integer NOT NULL,
    sender character varying NOT NULL,
    recipient character varying NOT NULL,
    subject character varying NOT NULL,
    state public.mailstate NOT NULL,
    id integer NOT NULL,
    external_id integer,
    body character varying NOT NULL,
    raw_email character varying NOT NULL,
    job_results json,
    errors json
);


ALTER TABLE public.mail_cache OWNER TO dev_admin;

--
-- Name: mail_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: dev_admin
--

CREATE SEQUENCE public.mail_cache_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mail_cache_id_seq OWNER TO dev_admin;

--
-- Name: mail_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev_admin
--

ALTER SEQUENCE public.mail_cache_id_seq OWNED BY public.mail_cache.id;


--
-- Name: mail_id_seq; Type: SEQUENCE; Schema: public; Owner: dev_admin
--

CREATE SEQUENCE public.mail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mail_id_seq OWNER TO dev_admin;

--
-- Name: mail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev_admin
--

ALTER SEQUENCE public.mail_id_seq OWNED BY public.mail.id;


--
-- Name: sender; Type: TABLE; Schema: public; Owner: dev_admin
--

CREATE TABLE public.sender (
    id integer NOT NULL,
    name character varying NOT NULL,
    mail_address character varying NOT NULL,
    info text
);


ALTER TABLE public.sender OWNER TO dev_admin;

--
-- Name: sender_account_link; Type: TABLE; Schema: public; Owner: dev_admin
--

CREATE TABLE public.sender_account_link (
    sender_id integer NOT NULL,
    account_id integer NOT NULL
);


ALTER TABLE public.sender_account_link OWNER TO dev_admin;

--
-- Name: sender_id_seq; Type: SEQUENCE; Schema: public; Owner: dev_admin
--

CREATE SEQUENCE public.sender_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sender_id_seq OWNER TO dev_admin;

--
-- Name: sender_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev_admin
--

ALTER SEQUENCE public.sender_id_seq OWNED BY public.sender.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: dev_admin
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying NOT NULL,
    info text,
    hashed_password character varying NOT NULL,
    is_active boolean NOT NULL,
    account_id integer NOT NULL
);


ALTER TABLE public."user" OWNER TO dev_admin;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: dev_admin
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO dev_admin;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev_admin
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: account id; Type: DEFAULT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);


--
-- Name: mail id; Type: DEFAULT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.mail ALTER COLUMN id SET DEFAULT nextval('public.mail_id_seq'::regclass);


--
-- Name: mail_cache id; Type: DEFAULT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.mail_cache ALTER COLUMN id SET DEFAULT nextval('public.mail_cache_id_seq'::regclass);


--
-- Name: sender id; Type: DEFAULT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.sender ALTER COLUMN id SET DEFAULT nextval('public.sender_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: dev_admin
--

COPY public.account (id, name, info, is_active, account_type) FROM stdin;
1	admin	Admin account	t	ADMIN
2	test	Test account	t	DEFAULT
3	Govno	govno	t	DEFAULT
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: dev_admin
--

COPY public.alembic_version (version_num) FROM stdin;
3959cd6411bf
\.


--
-- Data for Name: mail; Type: TABLE DATA; Schema: public; Owner: dev_admin
--

COPY public.mail (id, time_received, sender, recipient, subject, state, body_url, raw_email_url, job_results, errors) FROM stdin;
4	2026-01-02 16:04:12+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/19ab9743-5034-4f31-812d-1f169d866e2a_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/19ab9743-5034-4f31-812d-1f169d866e2a_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
5	2026-01-02 16:13:17+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/ccf08c6b-cf2c-4316-bb40-4506acdf4b44_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/ccf08c6b-cf2c-4316-bb40-4506acdf4b44_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
7	2026-01-02 16:13:19+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/3b869d0e-1dd1-4eb2-ab53-03974a18c912_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/3b869d0e-1dd1-4eb2-ab53-03974a18c912_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
8	2026-01-02 16:13:20+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/964715a2-68ad-4ed0-9e9a-d0647352f33d_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/964715a2-68ad-4ed0-9e9a-d0647352f33d_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
9	2026-01-02 16:13:21+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/dad7d4dd-d0c1-4080-bc52-4d291a7d6f95_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/dad7d4dd-d0c1-4080-bc52-4d291a7d6f95_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
10	2026-01-02 16:13:21+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/bc0a873c-8b7e-4a33-b2fb-c559299bf76a_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/bc0a873c-8b7e-4a33-b2fb-c559299bf76a_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
11	2026-01-02 16:13:22+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/d7b727d9-dfb0-4785-a41a-ee8cd837445e_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/d7b727d9-dfb0-4785-a41a-ee8cd837445e_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
12	2026-01-02 16:13:23+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/b3d34b81-9ed1-4884-87ad-60389dfedbaa_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/b3d34b81-9ed1-4884-87ad-60389dfedbaa_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
13	2026-01-02 16:13:23+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/4d92880b-703f-4977-8ae4-3c0096c65bdf_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/4d92880b-703f-4977-8ae4-3c0096c65bdf_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
14	2026-01-02 16:13:24+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/97a63e83-9659-4216-8e49-77858e4ddeda_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/97a63e83-9659-4216-8e49-77858e4ddeda_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
15	2026-01-02 16:13:24+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/02d63391-2c8c-4262-8b9b-6b2ea992d864_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/02d63391-2c8c-4262-8b9b-6b2ea992d864_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
16	2026-01-02 16:13:25+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/429ec77f-0948-4585-8cd9-0963ff091adc_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/429ec77f-0948-4585-8cd9-0963ff091adc_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
17	2026-01-02 16:13:25+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/d63915b8-b50f-4a69-a5d2-a4a97aee6adc_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/d63915b8-b50f-4a69-a5d2-a4a97aee6adc_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
18	2026-01-02 16:13:26+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/5e9e0f24-4461-4b31-a377-a1f5475c405e_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/5e9e0f24-4461-4b31-a377-a1f5475c405e_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
19	2026-01-02 16:13:27+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/b74d183e-e986-4489-b864-2dbb55d4b741_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/b74d183e-e986-4489-b864-2dbb55d4b741_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
20	2026-01-02 16:13:27+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/2685b67c-f785-48cf-ade3-86735eed6905_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/2685b67c-f785-48cf-ade3-86735eed6905_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
21	2026-01-02 16:13:28+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/725fe39d-f3e8-4feb-9a63-cddf1300d7ca_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/725fe39d-f3e8-4feb-9a63-cddf1300d7ca_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
22	2026-01-02 16:13:28+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/e1e01042-a423-432f-a732-b7ff411af58f_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/e1e01042-a423-432f-a732-b7ff411af58f_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
23	2026-01-02 16:17:44+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/05af260e-b3ff-4d6f-8e71-c0204125933d_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/05af260e-b3ff-4d6f-8e71-c0204125933d_body.txt	{"ai_summary": "This email announces three new features for the platform: an advanced analytics dashboard, seamless third-party app integration, and enhanced security protocols. Customers are encouraged to visit the website for more details.", "ai_personalization": {"tech_stack": {"raw_score": 1, "weighted_points": 6}, "subject_line": {"raw_score": 1, "weighted_points": 2}, "textual_personalization": {"raw_score": 1, "weighted_points": 6}, "visual_content": {"raw_score": 1, "weighted_points": 6}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 1, "weighted_points": 4}, "dynamic_asset_structuring": {"raw_score": 1, "weighted_points": 1}, "total_score": 30, "maturity_level": 5}, "ai_spam_check": true, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
24	2026-01-02 16:18:02+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/0002ae8b-ba4a-47ad-8a30-40dacfcd87b6_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/0002ae8b-ba4a-47ad-8a30-40dacfcd87b6_body.txt	{"ai_summary": "This newsletter announces three new platform features: an advanced analytics dashboard, seamless integration with third-party apps, and enhanced security protocols. Customers are encouraged to visit the website for more details.", "ai_personalization": {"tech_stack": {"raw_score": 1, "weighted_points": 6}, "subject_line": {"raw_score": 1, "weighted_points": 2}, "textual_personalization": {"raw_score": 2, "weighted_points": 12}, "visual_content": {"raw_score": 1, "weighted_points": 6}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 1, "weighted_points": 4}, "dynamic_asset_structuring": {"raw_score": 1, "weighted_points": 1}, "total_score": 36, "maturity_level": 5}, "ai_spam_check": true, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
26	2026-01-02 16:18:04+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/f6589075-18c4-46fa-ba35-ddb5669348fe_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/f6589075-18c4-46fa-ba35-ddb5669348fe_body.txt	{"ai_summary": "This email announces three new features for the platform: an advanced analytics dashboard, integration with third-party apps, and enhanced security protocols. Customers are encouraged to visit the website for more details.", "ai_personalization": {"tech_stack": {"raw_score": 1, "weighted_points": 6}, "subject_line": {"raw_score": 1, "weighted_points": 2}, "textual_personalization": {"raw_score": 2, "weighted_points": 12}, "visual_content": {"raw_score": 1, "weighted_points": 6}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 1, "weighted_points": 4}, "dynamic_asset_structuring": {"raw_score": 1, "weighted_points": 1}, "total_score": 36, "maturity_level": 5}, "ai_spam_check": true, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
27	2026-01-02 16:18:05+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/3e78f0c5-6a82-447e-9b95-8db7b4e1b267_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/3e78f0c5-6a82-447e-9b95-8db7b4e1b267_body.txt	{"ai_summary": "This newsletter announces three new features: an advanced analytics dashboard, integration with third-party apps, and enhanced security protocols. Customers are encouraged to visit the website for more details.", "ai_personalization": {"tech_stack": {"raw_score": 1, "weighted_points": 6}, "subject_line": {"raw_score": 1, "weighted_points": 2}, "textual_personalization": {"raw_score": 1, "weighted_points": 6}, "visual_content": {"raw_score": 1, "weighted_points": 6}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 1, "weighted_points": 4}, "dynamic_asset_structuring": {"raw_score": 1, "weighted_points": 1}, "total_score": 30, "maturity_level": 5}, "ai_spam_check": true, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
28	2026-01-02 16:18:06+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/ab0d2fd1-a7c4-4aeb-99d6-e4f6121f4bda_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/ab0d2fd1-a7c4-4aeb-99d6-e4f6121f4bda_body.txt	{"ai_summary": "This newsletter announces three new platform features: an advanced analytics dashboard for real-time insights, seamless integration with third-party apps, and enhanced security protocols. Customers are encouraged to visit the website for more details.", "ai_personalization": {"tech_stack": {"raw_score": 1, "weighted_points": 6}, "subject_line": {"raw_score": 1, "weighted_points": 2}, "textual_personalization": {"raw_score": 1, "weighted_points": 6}, "visual_content": {"raw_score": 1, "weighted_points": 6}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 1, "weighted_points": 4}, "dynamic_asset_structuring": {"raw_score": 1, "weighted_points": 1}, "total_score": 30, "maturity_level": 5}, "ai_spam_check": true, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
29	2026-01-02 16:18:06+00	sender@test.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/b4ccef6a-1729-4d12-90f8-f8b5b1225d18_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/b4ccef6a-1729-4d12-90f8-f8b5b1225d18_body.txt	{"ai_summary": "This email announces three new features: an advanced analytics dashboard, seamless third-party app integration, and enhanced security protocols, aimed at improving customer experience and data protection. Customers are encouraged to visit the website for more information.", "ai_personalization": {"tech_stack": {"raw_score": 1, "weighted_points": 6}, "subject_line": {"raw_score": 1, "weighted_points": 2}, "textual_personalization": {"raw_score": 1, "weighted_points": 6}, "visual_content": {"raw_score": 1, "weighted_points": 6}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 1, "weighted_points": 4}, "dynamic_asset_structuring": {"raw_score": 1, "weighted_points": 1}, "total_score": 30, "maturity_level": 5}, "ai_spam_check": true, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
25	2026-01-02 16:18:03+00	sender@test.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/2942040e-d586-492a-b8a4-b1043c44f21d_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/2942040e-d586-492a-b8a4-b1043c44f21d_body.txt	{"ai_summary": "This email announces the launch of three new features: an advanced analytics dashboard, seamless integration with third-party apps, and enhanced security protocols, all aimed at improving the customer's experience and data protection.", "ai_personalization": {"tech_stack": {"raw_score": 1, "weighted_points": 6}, "subject_line": {"raw_score": 1, "weighted_points": 2}, "textual_personalization": {"raw_score": 1, "weighted_points": 6}, "visual_content": {"raw_score": 1, "weighted_points": 6}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 1, "weighted_points": 4}, "dynamic_asset_structuring": {"raw_score": 1, "weighted_points": 1}, "total_score": 30, "maturity_level": 5}, "ai_spam_check": true, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
6	2026-01-02 16:13:18+00	sender@test.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/028b42b7-defa-4699-b344-21061ff03e11_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/028b42b7-defa-4699-b344-21061ff03e11_body.txt	{"ai_summary": "This is a mock summary of the email content.", "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}, "ai_spam_check": false, "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}}	null
30	2026-01-05 17:28:36+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/5fe44820-76d1-4eac-8d29-2967a9c10c61_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/5fe44820-76d1-4eac-8d29-2967a9c10c61_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
31	2026-01-05 22:47:28+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/7f8ba5eb-de9b-4c47-93bd-de00e1397282_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/7f8ba5eb-de9b-4c47-93bd-de00e1397282_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
32	2026-01-05 22:49:09+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/d3c19ece-3bd9-4870-b313-c6b4606caeaa_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/d3c19ece-3bd9-4870-b313-c6b4606caeaa_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
33	2026-01-05 22:51:12+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/938a7d1d-9d1e-4413-b991-162531992cb7_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/938a7d1d-9d1e-4413-b991-162531992cb7_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
34	2026-01-05 23:04:47+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/7e0aa866-6bb7-40d4-9b5a-1c4a4516249c_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/7e0aa866-6bb7-40d4-9b5a-1c4a4516249c_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
35	2026-01-05 23:04:50+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/e50ce823-904c-45f3-8f9f-734c8634e184_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/e50ce823-904c-45f3-8f9f-734c8634e184_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
36	2026-01-05 23:58:28+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/d3e611e5-70ed-4fa5-bbfd-5699e6282878_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/d3e611e5-70ed-4fa5-bbfd-5699e6282878_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
37	2026-01-06 00:18:43+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/4eab0522-4c55-4a2a-aed8-ea128a38297b_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/4eab0522-4c55-4a2a-aed8-ea128a38297b_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 771, "line_count": 21, "paragraph_count": 4, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023346303501945526, "digit_ratio": 0.0, "special_char_ratio": 0.018158236057068743, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
38	2026-01-06 00:39:35+00	sender@example.com	receiver@example.com	Test Email	PROCESSED	https://mailmarketing1.blob.core.windows.net/mail-content-container/raw_emails/be840284-7d71-49ed-b509-db6239b40fc7_raw.eml	https://mailmarketing1.blob.core.windows.net/mail-content-container/email_bodies/be840284-7d71-49ed-b509-db6239b40fc7_body.txt	{"ai_summary": "This is a mock summary of the email content.", "metrics": {"word_count": 101, "char_count": 751, "line_count": 21, "paragraph_count": 9, "sentence_count": 7, "average_word_length": 5.871287128712871, "reading_time_seconds": 30.3, "uppercase_ratio": 0.023968042609853527, "digit_ratio": 0.0, "special_char_ratio": 0.018641810918774968, "link_count": 1, "email_mentions": 0, "vocabulary_richness": 0.8118811881188119}, "ai_spam_check": false, "ai_personalization": {"tech_stack": {"raw_score": 2, "weighted_points": 12}, "subject_line": {"raw_score": 2, "weighted_points": 4}, "textual_personalization": {"raw_score": 3, "weighted_points": 18}, "visual_content": {"raw_score": 2, "weighted_points": 12}, "personalization_modules": {"raw_score": 1, "weighted_points": 5}, "campaign_tracking": {"raw_score": 2, "weighted_points": 8}, "dynamic_asset_structuring": {"raw_score": 2, "weighted_points": 2}, "total_score": 61, "maturity_level": 5}}	null
\.


--
-- Data for Name: mail_cache; Type: TABLE DATA; Schema: public; Owner: dev_admin
--

COPY public.mail_cache (time_received, sender, recipient, subject, state, id, external_id, body, raw_email, job_results, errors) FROM stdin;
\.


--
-- Data for Name: sender; Type: TABLE DATA; Schema: public; Owner: dev_admin
--

COPY public.sender (id, name, mail_address, info) FROM stdin;
1	Example PL	sender@example.com	Example sender
2	Test PL	sender@test.com	Test sender
3	Test 2 PL	sender2@test2.com	Test 2 sender
5	123123	123123123@wer.com	\N
\.


--
-- Data for Name: sender_account_link; Type: TABLE DATA; Schema: public; Owner: dev_admin
--

COPY public.sender_account_link (sender_id, account_id) FROM stdin;
1	2
2	2
3	2
5	2
5	3
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: dev_admin
--

COPY public."user" (id, username, info, hashed_password, is_active, account_id) FROM stdin;
1	avrutin	admin	$argon2id$v=19$m=65536,t=3,p=4$mFf9RQruKvXz6hc9fA/oCg$l/S7ugCmNmVqRWOxVHxGkTP5UhqklbtUk6oR694I8Jk	t	1
2	user@user.user	123123123123	$argon2id$v=19$m=65536,t=3,p=4$VsCEzv1Coa4J6hkAjBVMSw$LDwYKjZuGTBfRZjEWWGzwzRDkoi9R3YUzIZsv01C4Sg	t	2
3	user@example.com	password: test_password	$argon2id$v=19$m=65536,t=3,p=4$a7EncGiD+XZXqgY1aj7kFg$J1JOtcv8kT75ISPKNP9x4Q9m7iZeIovlBNiY0MrmqD0	t	2
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev_admin
--

SELECT pg_catalog.setval('public.account_id_seq', 3, true);


--
-- Name: mail_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev_admin
--

SELECT pg_catalog.setval('public.mail_cache_id_seq', 1, false);


--
-- Name: mail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev_admin
--

SELECT pg_catalog.setval('public.mail_id_seq', 38, true);


--
-- Name: sender_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev_admin
--

SELECT pg_catalog.setval('public.sender_id_seq', 5, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev_admin
--

SELECT pg_catalog.setval('public.user_id_seq', 3, true);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: mail_cache mail_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.mail_cache
    ADD CONSTRAINT mail_cache_pkey PRIMARY KEY (id);


--
-- Name: mail mail_pkey; Type: CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.mail
    ADD CONSTRAINT mail_pkey PRIMARY KEY (id);


--
-- Name: sender_account_link sender_account_link_pkey; Type: CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.sender_account_link
    ADD CONSTRAINT sender_account_link_pkey PRIMARY KEY (sender_id, account_id);


--
-- Name: sender sender_pkey; Type: CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.sender
    ADD CONSTRAINT sender_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_account_name; Type: INDEX; Schema: public; Owner: dev_admin
--

CREATE UNIQUE INDEX ix_account_name ON public.account USING btree (name);


--
-- Name: ix_mail_cache_external_id; Type: INDEX; Schema: public; Owner: dev_admin
--

CREATE INDEX ix_mail_cache_external_id ON public.mail_cache USING btree (external_id);


--
-- Name: ix_mail_cache_state; Type: INDEX; Schema: public; Owner: dev_admin
--

CREATE INDEX ix_mail_cache_state ON public.mail_cache USING btree (state);


--
-- Name: ix_mail_state; Type: INDEX; Schema: public; Owner: dev_admin
--

CREATE INDEX ix_mail_state ON public.mail USING btree (state);


--
-- Name: ix_sender_mail_address; Type: INDEX; Schema: public; Owner: dev_admin
--

CREATE UNIQUE INDEX ix_sender_mail_address ON public.sender USING btree (mail_address);


--
-- Name: ix_sender_name; Type: INDEX; Schema: public; Owner: dev_admin
--

CREATE UNIQUE INDEX ix_sender_name ON public.sender USING btree (name);


--
-- Name: ix_user_username; Type: INDEX; Schema: public; Owner: dev_admin
--

CREATE UNIQUE INDEX ix_user_username ON public."user" USING btree (username);


--
-- Name: sender_account_link sender_account_link_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.sender_account_link
    ADD CONSTRAINT sender_account_link_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id);


--
-- Name: sender_account_link sender_account_link_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public.sender_account_link
    ADD CONSTRAINT sender_account_link_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.sender(id);


--
-- Name: user user_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dev_admin
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id);


--
-- PostgreSQL database dump complete
--

\unrestrict qfb0ip1M9zirAxAWXIkSCOAwFFrHFxAs1fB5f3yW5KIyM3JeN4tquCazFrXjgmy

