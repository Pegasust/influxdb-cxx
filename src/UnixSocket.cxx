///
/// \author Adam Wegrzynek <adam.wegrzynek@cern.ch>
///

#include "UnixSocket.h"
#include "InfluxDBException.h"
#include <string>

namespace influxdb::transports
{
#if defined(BOOST_ASIO_HAS_LOCAL_SOCKETS)

UnixSocket::UnixSocket(const std::string &socketPath) :
  mSocket(mIoService), mEndpoint(socketPath)
{
  mSocket.open();
}

void UnixSocket::send(std::string &&message)
{
  try
  {
    mSocket.send_to(boost::asio::buffer(message, message.size()), mEndpoint);
  }
  catch (const boost::system::system_error &e)
  {
    throw InfluxDBException(__PRETTY_FUNCTION__, e.what());
  }
}

#endif // defined(BOOST_ASIO_HAS_LOCAL_SOCKETS)

} // namespace influxdb::transports
