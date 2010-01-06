#include <string>
#include <sstream>


template<class type>
inline std::string toString(const type& value)
{
    std::ostringstream streamOut;
    streamOut << value;
	return streamOut.str();
}
