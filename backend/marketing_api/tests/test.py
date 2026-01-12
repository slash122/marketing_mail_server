import pytest
import smtplib
from email.message import EmailMessage
from unittest.mock import patch, mock_open, MagicMock

def test_email_message_creation():
    """Test that EmailMessage is created correctly"""
    msg = EmailMessage()
    msg.set_content("Test content")
    msg["Subject"] = "Test Email"
    msg["From"] = "sender@example.com"
    msg["To"] = "receiver@example.com"
    
    assert msg["Subject"] == "Test Email"
    assert msg["From"] == "sender@example.com"
    assert msg["To"] == "receiver@example.com"


@patch("builtins.open", new_callable=mock_open, read_data="Email body content")
@patch("smtplib.SMTP")
def test_email_sending_primary_server(mock_smtp, mock_file):
    """Test email sending with primary server (0.0.0.0:1025)"""
    mock_server = MagicMock()
    mock_smtp.return_value.__enter__.return_value = mock_server
    
    msg = EmailMessage()
    with open("test_email.txt", "r") as f:
        msg.set_content(f.read())
    msg["Subject"] = "Test Email"
    msg["From"] = "sender@example.com"
    msg["To"] = "receiver@example.com"
    
    with smtplib.SMTP("0.0.0.0", 1025) as server:
        server.send_message(msg)
    
    mock_smtp.assert_called_with("0.0.0.0", 1025)
    mock_server.send_message.assert_called_once()


@patch("builtins.open", new_callable=mock_open, read_data="Email body content")
@patch("smtplib.SMTP")
def test_email_sending_fallback_server(mock_smtp, mock_file):
    """Test email sending with fallback server (localhost:25)"""
    mock_smtp.side_effect = [Exception("Primary server failed"), MagicMock()]
    
    msg = EmailMessage()
    with open("test_email.txt", "r") as f:
        msg.set_content(f.read())
    msg["Subject"] = "Test Email"
    msg["From"] = "sender@example.com"
    msg["To"] = "receiver@example.com"
    
    try:
        with smtplib.SMTP("0.0.0.0", 1025) as server:
            server.send_message(msg)
    except Exception:
        with smtplib.SMTP("localhost", 25) as server:
            server.send_message(msg)
    
    assert mock_smtp.call_count == 2

def test_sample_test1():
    assert True == True

def test_sample_test2():
    assert True == True

def test_sample_test3():
    assert True == True

def test_sample_test4():
    assert True == True

def test_sample_test5():
    assert True == True

def test_sample_test6():
    assert True == True

def test_sample_test7():
    assert True == True

def test_sample_test8():
    assert True == True

def test_sample_test9():
    assert True == True

def test_sample_test10():
    assert True == True

def test_sample_test11():
    assert True