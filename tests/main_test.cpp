#include <gtest/gtest.h>
#include <QCoreApplication>

int main(int argc, char *argv[]) {
    //initialize Qt global state so QSqlDatabase and other Qt classes work
    QCoreApplication app(argc, argv);
    
    //initialize GoogleTest
    ::testing::InitGoogleTest(&argc, argv);
    
    //run all registered tests
    return RUN_ALL_TESTS();
}