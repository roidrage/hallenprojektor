# Inspired by GitNub's ImageLoadOperation
require 'osx/cocoa'

class LoadOperation < OSX::NSOperation
  attr_accessor :username, :password, :on_success, :on_error
  include OSX
  
  def initWithURL_delegate(url, delegate)
    init
    
    @url = url
    @delegate = delegate
    @executing = false
    @finished = false
    self
  end
  
  def isConcurrent
    true
  end
  
  def start
    request = NSURLRequest.requestWithURL_cachePolicy_timeoutInterval(@url, NSURLRequestReloadIgnoringLocalCacheData, 10.0)
    @connection = NSURLConnection.connectionWithRequest_delegate(request, self)
    setExecuting true
  end
  
  def cancel
    super
    @connection.cancel
    setExecuting false
  end
  
  def isExecuting
    @executing
  end
  
  def isFinished
    @finished
  end
  
  # NSURLConnection Delegate methods
  def connection_didFailWithError(connection, error)
    unless on_error.nil?
      @delegate.send(on_error.to_sym, @url, error)
    else
      @delegate.load_url_failed(@url, error)
    end
    setExecuting false
    setFinished true
  end
  
  def connection_didReceiveResponse(connection, response)
    if response.statusCode == 404
      puts "got 404 error"
      connection.cancel
      unless on_error.nil?
        @delegate.send(on_error.to_sym, @url, 404)
      else
        @delegate.load_url_failed(@url, 404)
      end
      setExecuting false
      setFinished true
    else
      @length = 0
      @data = NSMutableData.dataWithCapacity(@length < 0 ? 0 : @length)
    end
  end
  
  def connection_didReceiveData(connection, data)
    @length += data.length
    @data.appendData(data)
  end
  
  def connectionDidFinishLoading(connection)
    data = @data.mutableBytes.bytestr(@length)
    unless on_success.nil?
      @delegate.send(on_success.to_sym, data)
    else
      @delegate.url_finished(data)
    end
    setExecuting false
    setFinished true
  end
  
  def connection_willSendRequest_redirectResponse(connection, request, redirectResponse)
    request
  end
  
  def connection_didReceiveAuthenticationChallenge(connection, challenge)
    if challenge.previousFailureCount == 0
      newCredential = NSURLCredential.credentialWithUser_password_persistence(username, password, NSURLCredentialPersistenceNone)
      challenge.sender.useCredential_forAuthenticationChallenge newCredential, challenge
    else
      challenge.sender.cancelAuthenticationChallenge challenge
    end
  end
  
  private
  
  def setExecuting(bool)
    self.willChangeValueForKey("isExecuting")
    @executing = bool
    self.didChangeValueForKey("isExecuting")
  end
  
  def setFinished(bool)
    self.willChangeValueForKey("isFinished")
    @finished = bool
    self.didChangeValueForKey("isFinished")
  end
end