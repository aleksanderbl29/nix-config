{
  version = 1;
  base_url = "http://127.0.0.1:8096";

  system = {
    enableMetrics = false;
    pluginRepositories = [
      {
        name = "Jellyfin Stable";
        url = "https://repo.jellyfin.org/files/plugin/manifest.json";
        enabled = true;
      }
      {
        name = "Intro skipper";
        url = "https://manifest.intro-skipper.org/manifest.json";
        enabled = true;
      }
      {
        name = "Infuse";
        url = "https://files.firecore.com/jellyfin/manifest.json";
        enabled = true;
      }
    ];
    trickplayOptions = {
      enableHwAcceleration = false;
      enableHwEncoding = false;
    };
  };

  encoding = {
    enableHardwareEncoding = true;
    hardwareAccelerationType = "qsv";
    vaapiDevice = "/dev/dri/renderD128";
    qsvDevice = "/dev/dri/renderD128";
    hardwareDecodingCodecs = [
      "h264"
      "vc1"
    ];
    enableDecodingColorDepth10Hevc = true;
    enableDecodingColorDepth10Vp9 = true;
    enableDecodingColorDepth10HevcRext = false;
    enableDecodingColorDepth12HevcRext = false;
    allowHevcEncoding = true;
    allowAv1Encoding = true;
  };

  library.virtualFolders = [
    {
      name = "Music";
      collectionType = "music";
      libraryOptions.pathInfos = [
        { path = "/mnt/media/music"; }
      ];
    }
    {
      name = "Movies";
      collectionType = "movies";
      libraryOptions.pathInfos = [
        { path = "/mnt/media/movies"; }
      ];
    }
    {
      name = "Shows";
      collectionType = "tvshows";
      libraryOptions.pathInfos = [
        { path = "/mnt/media/tv"; }
      ];
    }
    {
      name = "Collections";
      collectionType = "boxsets";
      libraryOptions.pathInfos = [
        { path = "/var/lib/jellyfin/data/collections"; }
      ];
    }
  ];

  branding = {
    loginDisclaimer = "";
    customCss = "";
    splashscreenEnabled = false;
  };

  users = [
    {
      name = "aleksander";
      password = "$JELLYFIN_PASSWORD_ALEKSANDER";
      policy = {
        isAdministrator = true;
        # loginAttemptsBeforeLockout = -1;
      };
    }
    {
      name = "jellyfin";
      password = "$JELLYFIN_PASSWORD_JELLYFIN";
      policy = {
        isAdministrator = true;
        # loginAttemptsBeforeLockout = -1;
      };
    }
  ];

  plugins = [
    {
      name = "AudioDB";
      configuration.ReplaceAlbumName = false;
    }
    {
      name = "InfuseSync";
      configuration.CacheExpirationDays = 30;
    }
    {
      name = "MusicBrainz";
      configuration = {
        Server = "https://musicbrainz.org";
        RateLimit = 1;
        ReplaceArtistName = false;
      };
    }
    {
      name = "OMDb";
      configuration.CastAndCrew = false;
    }
    {
      name = "Open Subtitles";
      configuration = {
        Username = "aleksanderbl";
        Password = "$OPEN_SUBTITLES_PASSWORD";
        CredentialsInvalid = false;
      };
    }
    {
      name = "Studio Images";
      configuration.RepositoryUrl = "https://raw.githubusercontent.com/jellyfin/emby-artwork/master/studios";
    }
    {
      name = "TMDb";
      configuration = {
        TmdbApiKey = "";
        IncludeAdult = true;
        ImportSeasonName = true;
      };
    }
    {
      name = "TMDb Box Sets";
      configuration = {
        MinimumNumberOfMovies = 2;
        StripCollectionKeywords = false;
      };
    }
    {
      # must be configured manually in the web ui
      name = "Trakt";
    }
  ];
}
