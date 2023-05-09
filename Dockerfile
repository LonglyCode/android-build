FROM gradle:7.4-jdk11
RUN apt-get update \
    && apt-get install build-essential file apt-utils -y
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_SDK_ROOT="/usr/local/android-sdk" \
    ANDROID_VERSION=33 \
    ANDROID_BUILD_TOOLS_VERSION=33.0.1

# Download Android SDK
RUN mkdir -p ~/.android \
    && touch ~/.android/repositories.cfg \
    && mkdir "$ANDROID_SDK_ROOT" .android \
    && cd "$ANDROID_SDK_ROOT" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip

# 使用commandlinetools-linux去下载
RUN cd "$ANDROID_SDK_ROOT" \
	&& curl -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip \ 
	&& unzip cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools \
	&& rm cmdline-tools.zip 

# Install Android Build Tool and Libraries
RUN $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --update \
	&& yes | $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager --licenses \
    && $ANDROID_SDK_ROOT/cmdline-tools/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"
    
# refer to chinese repository
RUN touch /home/gradle/.gradle/init.gradle &&                           \
    echo "allprojects{                                                     \
    repositories {   \
        def ALIYUN_REPOSITORY_URL = 'https://maven.aliyun.com/repository/central/'     \
        def ALIYUN_JCENTER_URL = 'https://maven.aliyun.com/repository/public/'   \
        all { ArtifactRepository repo ->   \
            if(repo instanceof MavenArtifactRepository){   \
                def url = repo.url.toString()   \
                if (url.startsWith('https://repo.maven.org/maven2') || url.startsWith('https://repo1.maven.org/maven2') || url.startsWith('http://repo.maven.org/maven2') || url.startsWith('http://repo1.maven.org/maven2')) {   \
                    remove repo   \
                }   \
                if (url.startsWith('https://jcenter.bintray.com/') || url.startsWith('http://jcenter.bintray.com/')) {   \
                    remove repo   \
                }   \
            }   \
        }   \
        maven { url ALIYUN_REPOSITORY_URL }   \
        maven { url ALIYUN_JCENTER_URL }   \
        maven { url 'https://maven.aliyun.com/repository/google/' }   \
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin/' }   \
        maven { url 'https://maven.aliyun.com/repository/jcenter/' }   \
    }   \
    buildscript{   \
        repositories {   \
            def ALIYUN_REPOSITORY_URL = 'https://maven.aliyun.com/repository/central/'   \
            def ALIYUN_JCENTER_URL = 'https://maven.aliyun.com/repository/public/'   \
            all { ArtifactRepository repo ->   \
                if(repo instanceof MavenArtifactRepository){   \
                    def url = repo.url.toString()   \
                    if (url.startsWith('https://repo.maven.org/maven2') || url.startsWith('https://repo1.maven.org/maven2') || url.startsWith('http://repo.maven.org/maven2') || url.startsWith('http://repo1.maven.org/maven2')) {   \
                        remove repo   \
                    }   \
                    if (url.startsWith('https://jcenter.bintray.com/') || url.startsWith('http://jcenter.bintray.com/')) {   \
                        remove repo   \
                    }   \
                }   \
            }   \
            maven { url ALIYUN_REPOSITORY_URL }   \
            maven { url ALIYUN_JCENTER_URL }   \
            maven { url 'https://maven.aliyun.com/repository/google/' }   \
            maven { url 'https://maven.aliyun.com/repository/gradle-plugin/' }   \
            maven { url 'https://maven.aliyun.com/repository/jcenter/' }   \
        }   \
    }   \
	}" /home/gradle/.gradle/init.gradle